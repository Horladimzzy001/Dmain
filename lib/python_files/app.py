import plotly.graph_objects as go

# Sample data - this would be replaced by your actual data
data = [
    {"northern": 100, "eastern": 200, "tvd": 150, "md": 1000, "inclination": 5, "azimuth": 60, "dogleg": 0.2},
    {"northern": 150, "eastern": 250, "tvd": 200, "md": 1100, "inclination": 7, "azimuth": 62, "dogleg": 0.3},
    {"northern": 200, "eastern": 300, "tvd": 250, "md": 1200, "inclination": 10, "azimuth": 65, "dogleg": 0.4},
    # Add more rows as needed
]

# Extract the selected data for the 3D plot
x = [row["northern"] for row in data]
y = [row["eastern"] for row in data]
z = [row["tvd"] for row in data]

# Create a 3D scatter plot
fig = go.Figure(data=[go.Scatter3d(
    x=x,
    y=y,
    z=z,
    mode='markers+lines',  # Can be 'lines', 'markers', or 'markers+lines'
    marker=dict(
        size=5,
        color=z,  # Color by z value
        colorscale='Viridis',  # Choose a colorscale
        opacity=0.8
    )
)])

# Set the title and axis labels
fig.update_layout(
    title='3D Plot of Well Path Data',
    scene=dict(
        xaxis_title='Northern',
        yaxis_title='Eastern',
        zaxis_title='True Vertical Depth (TVD)',
    ),
    margin=dict(l=0, r=0, b=0, t=50)  # Adjust margins to fit the plot within the frame
)

# Add interactive camera controls
fig.update_layout(scene_camera=dict(
    eye=dict(x=1.5, y=1.5, z=1.5)  # Initial camera position
))

# Show the plot
print("Script is running...")

fig.show()
