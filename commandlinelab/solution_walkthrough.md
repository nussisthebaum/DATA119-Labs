# Solution Walkthrough

## Step 1

Grep for clues. You only need to grep the `crimescene` file.

```bash
cd data
cd mystery
ls
```

Output:
```
cheatsheet.md.save
crimescene
interviews
memberships
people
streets
vehicles
```

```bash
cd data
cd mystery
grep "CLUE" crimescene
```

Output:
```
CLUE: Footage from an ATM security camera is blurry but shows that the perpetrator is a tall male, at least 6'.
CLUE: Found a wallet believed to belong to the killer: no ID, just loose change, and membership cards for AAA, Delta SkyMiles, the local library, and the Museum of Bash History. The cards are totally untraceable and have no name, for some reason.
CLUE: Questioned the barista at the local coffee shop. He said a woman left right before they heard the shots. The name on her latte was Annabel, she had blond spiky hair and a New Zealand accent.
```

## Step 2

Based on the third clue, we can grep the `interviews` folder for clues. We can try various queries including: "Annabel", "blond", "spiky", and "Zealand."

```bash
cd data
cd mystery
cd interviews
grep "Zealand" *
```

Output:
```
interview-47246024:Ms. Sun has brown hair and is not from New Zealand.  Not the witness from the cafe.
interview-94126412:is, you know. Please, Ma'am, is this New Zealand or Australia?' (and
```

## Step 3

We can find all people named Annabel, and rule out Annabel Sun, per Step 2. We know the person who left is a woman, so it must be Annabel Church.

```bash
cd data
cd mystery
cat people | grep "Annabel"
```

Output:
```
Annabel Sun F   26  Hart Place, line 40
Oluwasegun Annabel  M   37  Mattapan Street, line 173
Annabel Church  F   38  Buckingham Place, line 179
Annabel Fuglsang    M   40  Haley Street, line 176
```

## Step 4

We can then grep for interviews with Church and view the file.

```bash
cd data
cd mystery
cd interviews
grep "Church" *
cat interview-699607
```

Output:
```
interview-699607:Interviewed Ms. Church at 2:04 pm.  Witness stated that she did not see anyone she could identify as the shooter, that she ran away as soon as the shots were fired.
Interviewed Ms. Church at 2:04 pm.  Witness stated that she did not see anyone she could identify as the shooter, that she ran away as soon as the shots were fired.

However, she reports seeing the car that fled the scene.  Describes it as a blue Honda, with a license plate that starts with "L337" and ends with "9"
```

## Step 5

We can then look for appropriate vehicles. We can grep for the license plate using regex, and then we need to manually sift through the results. We want to look for Blue Hondas based on the interview with Annabel Church, and we want to look for people who are at least 6’ based on one of the original crime scene clues.

```bash
cd data/mystery
cat vehicles
grep -A 5 'L337.*9' vehicles
grep -A 5 'L337.*9' vehicles | grep -e "--" -e "Owner" -e "Height" -e "Color" -e "Make"
```

(Filtered) Output:
```
Make: Honda
Color: Blue
Owner: Erika Owens
Height: 6'5"

Make: Honda
Color: Blue
Owner: Joe Germuska
Height: 6'2"

Make: Honda
Color: Blue
Owner: Jeremy Bowers
Height: 6'1"

Make: Honda
Color: Blue
Owner: Jacqui Maher
Height: 6'2"
```

## Step 6

We can then use the information about the membership cards from the last crimescene clue. We want to find the intersection between the 4 files which correspond to his membership cards.

```bash
cd data
cd mystery
cd memberships
ls
```

```bash
cd data/mystery/memberships

grep -f AAA Delta_SkyMiles > merge1.txt
grep -f Museum_of_Bash_History merge1.txt > merge2.txt
grep -f Terminal_City_Library merge2.txt > merge3.txt

wc -l merge1.txt
wc -l merge2.txt
wc -l merge3.txt
```

We can then grep the final file for all of the last names from our candidates from Step 5.

```bash
cat merge3.txt | grep -e "Owens" -e "Germuska" -e "Bowers" -e "Maher"
```

Output:
```
Jacqui Maher
Jeremy Bowers
```

## Step 7

We can then examine the `people` file for the last 2 candidates

```bash
cd data
cd mystery
cat people | grep -e "Maher" -e "Bowers"
```

Output:
```
Maher Vos   M   55  Waltham Street, line 340
Jacqui Maher    F   40  Andover Road, line 224
Jeremy Bowers   M   34  Dunstable Road, line 284
```

**Jeremy Bowers** is the solution! because we know the perpetrator is male based on one of the crimescene clues.
