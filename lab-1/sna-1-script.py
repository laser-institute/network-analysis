import networkx as nx
import pandas as pd
import matplotlib.pyplot as plt

student_friends = pd.read_excel("data/student-reported-friends.xlsx",header=None)
student_friends

# Read Excel file into a DataFrame
student_attributes = pd.read_excel("data/student-attributes.xlsx")

# Display the DataFrame
print(student_attributes)

# Read Excel file into a DataFrame
teacher_friends = pd.read_excel("data/teacher-reported-friends.xlsx",header=None)

# Display the DataFrame
teacher_friends

# Convert DataFrame to a directed graph
student_network = nx.from_pandas_adjacency(student_friends, create_using=nx.DiGraph())

# Display basic information about the graph
print(student_network)

# Extract edges and convert to a DataFrame
student_edges = pd.DataFrame(student_network.edges(), columns=["from", "to"])

# Display the DataFrame
print(student_edges)

#Add nodes
nodes_df = pd.DataFrame(student_attributes[['id', 'gender', 'achievement', 'gender_num', 'achievement_num']])

# Add node attributes to the graph
for node_id, node_data in nodes_df.iterrows():
    # Ensure that the node ID exists in the graph before updating attributes
    if node_data['id'] in student_network.nodes:
        student_network.nodes[node_data['id']].update(node_data.to_dict())

# Print the graph summary
print(student_network)

teacher_network = nx.from_pandas_adjacency(teacher_friends, create_using=nx.DiGraph())

# Display basic information about the graph
print(teacher_network)

nx.draw(student_network, with_labels=True, font_weight='bold')
plt.show()
