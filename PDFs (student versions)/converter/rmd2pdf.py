"""Convert a learnr tutorial .Rmd into a static student-version PDF (via pandoc + xelatex).

- Exercises -> labeled code boxes (starter code or blank lines)
- Hints kept; solutions, checks, setup and secret-word post_messages dropped
- question()/question_numeric() -> numbered multiple choice / short answer (no correct answers)
- Displayed (non-exercise) Python chunks are executed and their output is shown
"""
import ast, io, os, re, subprocess, sys, contextlib, traceback

src, out_pdf = sys.argv[1], sys.argv[2]
lab_dir = os.path.dirname(os.path.abspath(src))
text = open(src, encoding="utf-8").read()

# ---- YAML / title ----
m = re.match(r"---\n(.*?)\n---\n", text, re.S)
yaml = m.group(1) if m else ""
text = text[m.end():] if m else text
tm = re.search(r'^title:\s*"?(.*?)"?\s*$', yaml, re.M)
title = tm.group(1).strip() if tm else os.path.basename(src)
hm = re.search(r'tags\$h1\("([^"]+)"', text)
if hm:
    title = hm.group(1)

text = re.sub(r"<!--.*?-->", "", text, flags=re.S)

# ---- R string-arg parsing for quiz questions ----
def r_args(s):
    """Split the top-level args of an R call body into a list of strings."""
    args, depth, cur, i, q = [], 0, "", 0, None
    while i < len(s):
        c = s[i]
        if q:
            cur += c
            if c == "\\" and i + 1 < len(s):
                cur += s[i + 1]; i += 2; continue
            if c == q: q = None
        elif c in "\"'": q = c; cur += c
        elif c in "([{": depth += 1; cur += c
        elif c in ")]}": depth -= 1; cur += c
        elif c == "," and depth == 0: args.append(cur.strip()); cur = ""
        else: cur += c
        i += 1
    if cur.strip(): args.append(cur.strip())
    return args

def r_str(a):
    a = a.strip()
    if len(a) >= 2 and a[0] in "\"'" and a[-1] == a[0]:
        return a[1:-1].replace('\\"', '"').replace("\\'", "'").replace("\\\\", "\\")
    return None

def call_body(code, fname):
    i = code.find(fname + "(")
    if i < 0: return None
    i += len(fname) + 1; depth, q, j = 1, None, i
    while j < len(code):
        c = code[j]
        if q:
            if c == "\\": j += 2; continue
            if c == q: q = None
        elif c in "\"'": q = c
        elif c == "(": depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0: return code[i:j]
        j += 1
    return None

qnum = [0]
def render_question(code):
    numeric = "question_numeric(" in code
    body = call_body(code, "question_numeric" if numeric else "question")
    if body is None: return ""
    args = r_args(body)
    qtext, answers, multi = None, [], False
    for a in args:
        if a.startswith("answer("):
            sub = r_args(call_body(a, "answer") or "")
            if sub and r_str(sub[0]) is not None:
                answers.append(r_str(sub[0]))
            if "correct = TRUE" in a.replace("correct=TRUE", "correct = TRUE"):
                multi_count = 1
        elif re.match(r"text\s*=", a):
            qtext = r_str(a.split("=", 1)[1])
        elif re.match(r"type\s*=", a) and "checkbox" in a:
            multi = True
        elif qtext is None and r_str(a) is not None and "=" not in a.split('"')[0]:
            qtext = r_str(a)
    ncorrect = len(re.findall(r"correct\s*=\s*TRUE", body))
    if ncorrect > 1: multi = True
    qnum[0] += 1
    out = [f"\n::: {{.quizbox}}\n**Question {qnum[0]}.** {qtext or ''}"]
    if multi and "apply" not in (qtext or ""): out[0] += " *(Select all that apply.)*"
    out.append("")
    if numeric or not answers:
        out.append("Answer: \\rule{6cm}{0.4pt}")
    else:
        out.append("\\\n".join(f"\\ensuremath{{\\square}} {a}" for a in answers))
    out.append(":::\n")
    return "\n".join(out)

# ---- Python execution (emulates knitr/reticulate output) ----
ns = {"__name__": "__main__"}
def run_py(code, show):
    buf = io.StringIO()
    cwd = os.getcwd(); os.chdir(lab_dir)
    try:
        tree = ast.parse(code)
        with contextlib.redirect_stdout(buf), contextlib.redirect_stderr(buf):
            for node in tree.body:
                if isinstance(node, ast.Expr):
                    v = eval(compile(ast.Expression(node.value), "<chunk>", "eval"), ns)
                    if v is not None and show:
                        print(repr(v) if not hasattr(v, "to_string") else v)
                else:
                    exec(compile(ast.Module([node], []), "<chunk>", "exec"), ns)
    except Exception as e:
        if show:
            buf.write("".join(traceback.format_exception_only(type(e), e)))
    finally:
        os.chdir(cwd)
    return buf.getvalue().rstrip("\n")

def opts(header):
    return header

# ---- Walk chunks ----
chunk_re = re.compile(r"^```\{(\w+)([^}]*)\}[ \t]*\n(.*?)^```[ \t]*$", re.S | re.M)
pieces, pos = [], 0
for cm in chunk_re.finditer(text):
    pieces.append(text[pos:cm.start()])
    pos = cm.end()
    eng, hdr, code = cm.group(1), cm.group(2), cm.group(3)
    h = hdr.replace(" ", "")
    nm = re.match(r",?\s*([A-Za-z0-9_.\-]+)\s*(,|$)", hdr.strip()) if not hdr.strip().startswith(",") else None
    name = nm.group(1) if nm and "=" not in nm.group(1) else ""
    is_ex = "exercise=TRUE" in h
    hidden = "echo=FALSE" in h or "include=FALSE" in h or 'context="setup"' in h
    noeval = "eval=FALSE" in h

    if name.endswith("-solution") or name.endswith("-check") or name.endswith("-code-check"):
        continue
    if re.search(r"-hint(-\d+)?$", name):
        pieces.append(f"\n::: {{.hintbox}}\n**Hint**\n\n```{'python' if eng=='python' else ''}\n{code.rstrip()}\n```\n:::\n")
        continue
    if eng == "r":
        if re.search(r"^\s*question(_numeric)?\(", code, re.M) and not noeval:
            pieces.append(render_question(code))
        continue
    if eng == "python":
        if is_ex:
            c = code.strip("\n")
            if c.strip():
                pieces.append(f"\n::: {{.exbox}}\n**Exercise**\n\n```python\n{c}\n```\n:::\n")
            else:
                pieces.append("\n::: {.exbox}\n**Exercise** — write your code here:\n\n\\vspace{3.2cm}\n:::\n")
            continue
        if hidden:
            if not noeval:
                run_py(code, False)
            continue
        block = f"\n```python\n{code.rstrip()}\n```\n"
        if not noeval:
            o = run_py(code, True)
            if o.strip():
                block += f"\n```{{.output}}\n{o}\n```\n"
        pieces.append(block)
        continue
    # other engines (bash/sql): show code only
    if not hidden:
        pieces.append(f"\n```{eng}\n{code.rstrip()}\n```\n")
pieces.append(text[pos:])
body = "".join(pieces)

# hint divs written in raw HTML
body = re.sub(r'<div id="[^"]*-hint">\s*(.*?)\s*</div>', r"\n::: {.hintbox}\n\1\n:::\n", body, flags=re.S)
body = body.replace("😉","").replace("😔","")
body = re.sub(r"\n{3,}", "\n\n", body)

md = f"""---
title: "{title}"
subtitle: "DATA 118 Lab — Student Version"
geometry: margin=1in
fontsize: 11pt
mainfont: DejaVu Serif
monofont: DejaVu Sans Mono
colorlinks: true
header-includes:
  - \\usepackage[most]{{tcolorbox}}
  - \\usepackage{{amssymb}}
  - \\usepackage{{fvextra}}
  - \\DefineVerbatimEnvironment{{Highlighting}}{{Verbatim}}{{breaklines,breakanywhere,commandchars=\\\\\\{{\\}}}}
  - \\fvset{{breaklines,breakanywhere}}
---

{body}
"""
md_path = os.path.splitext(out_pdf)[0] + ".md"
open(md_path, "w", encoding="utf-8").write(md)
here = os.path.dirname(os.path.abspath(__file__))
subprocess.run(["pandoc", md_path, "-o", out_pdf, "--pdf-engine=xelatex",
                "--lua-filter", os.path.join(here, "boxes.lua"),
                "--highlight-style=tango", "--resource-path", lab_dir], check=True)
print("wrote", out_pdf, "questions:", qnum[0])
