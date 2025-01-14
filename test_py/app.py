from shiny import ui, App, render

app_ui = ui.page_fluid(
    ui.input_slider("n", "Number of bins", min=10, max=100, value=30),
    ui.output_plot("hist"),
)

def server(input, output, session):
    @output
    @render.plot
    def hist():
        import numpy as np
        import matplotlib.pyplot as plt
        x = np.random.randn(1000)
        plt.hist(x, bins=input.n())

app = App(app_ui, server)
