import shiny

app_ui = shiny.ui.page_fluid(
    shiny.ui.input_slider("n", "Number of bins", min=10, max=100, value=30),
    shiny.ui.output_plot("hist"),
)

def server(input, output, session):
    @output
    @render.plot
    def hist():
        import numpy as np
        import matplotlib.pyplot as plt
        x = np.random.randn(1000)
        plt.hist(x, bins=input.n())

app = shiny.App(app_ui, server)
