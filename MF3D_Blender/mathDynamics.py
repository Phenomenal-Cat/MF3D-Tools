# Node Authors: Secrop, Rich Sedman
# Node Description: Dynamic Maths node with variable number of inputs
# version: (0,0,1)

import bpy

# for blender2.80 we should derive the class from bpy.types.ShaderNodeCustomGroup
class MathsDynamic(bpy.types.CompositorNodeCustomGroup):

    bl_name='MathsDynamic'
    bl_label='Dynamic Maths'

    # Return the list of valid operators
    def operators(self, context):
        nt=context.space_data.edit_tree
        list=[('ADD','Add','Addition'),('SUBTRACT', 'Subtract', 'Subtraction'), ('MULTIPLY', 'Multiply', 'Multiplication'), ('DIVIDE', 'Divide', 'Division'), ('MAXIMUM','Max','Maximum'),('MINIMUM','Min','Minimum') ]
        return list            

    # Manage the node's sockets, adding additional ones when needed and removing those no longer required
    def __nodeinterface_setup__(self):

        # No operators --> no inpout or output sockets
        if self.inputSockets < 1:
            self.node_tree.inputs.clear()
            self.node_tree.outputs.clear()

            return

        # Look for input sockets that are no longer required and remove them
        for i in range(len(self.node_tree.inputs),0,-1):
            if i > self.inputSockets:
                self.node_tree.inputs.remove(self.node_tree.inputs[-1])

        # Add any additional input sockets that are now required
        for i in range(0, self.inputSockets):
            if i > len(self.node_tree.inputs):
                self.node_tree.inputs.new("NodeSocketFloat", "Value")

        # Add the output socket
        if len(self.node_tree.outputs) < 1:
            self.node_tree.outputs.new("NodeSocketFloat", "Value")

    # Manage the internal nodes to perform the chained operation - clear all the nodes and build from scratch each time.
    def __nodetree_setup__(self):

        # Remove all links and all nodes that aren't Group Input or Group Output
        self.node_tree.links.clear()
        for node in self.node_tree.nodes:
            if not node.name in ['Group Input','Group Output']:
                self.node_tree.nodes.remove(node)

        # Start from Group Input and add nodes as required, chaining each new one to the previous level and the next input
        groupinput = self.node_tree.nodes['Group Input']
        previousnode = groupinput
        if self.inputSockets <= 1:
            # Special case <= 1 input --> link input directly to output
            self.node_tree.links.new(previousnode.outputs[0],self.node_tree.nodes['Group Output'].inputs[0])
        else:
            # Create one node for each input socket > 1
            for i in range(1, self.inputSockets):
                newnode = self.node_tree.nodes.new('CompositorNodeMath')
                newnode.operation = self.selectOperator
                self.node_tree.links.new(previousnode.outputs[0],newnode.inputs[0])
                self.node_tree.links.new(groupinput.outputs[i],newnode.inputs[1])
                previousnode = newnode

            # Connect the last one to the output
            self.node_tree.links.new(previousnode.outputs[0],self.node_tree.nodes['Group Output'].inputs[0])

    # Chosen operator has changed - update the nodes and links
    def update_operator(self, context):
        self.__nodeinterface_setup__()
        self.__nodetree_setup__()

    # Number of inputs has changed - update the nodes and links
    def update_inpSockets(self, context):
        self.__nodeinterface_setup__()
        self.__nodetree_setup__()

    # The node properties - Operator (Add, Subtract, etc.) and number of input sockets
    # for blender 2.80, the following properties should be annotations
    selectOperator=bpy.props.EnumProperty(name="selectOperator", items=operators, update=update_operator)    
    inputSockets=bpy.props.IntProperty(name="Inputs", min=0, max=63, default=0, update=update_inpSockets)

    # Setup the node - setup the node tree and add the group Input and Output nodes
    def init(self, context):
        self.node_tree=bpy.data.node_groups.new('.' + self.bl_name, 'CompositorNodeTree')
        self.node_tree.nodes.new('NodeGroupInput')
        self.node_tree.nodes.new('NodeGroupOutput') 

    # Draw the node components
    def draw_buttons(self, context, layout):
        row=layout.row()
        row.alert=(self.selectOperator=='None')
        row.prop(self, 'selectOperator', text='')
        row=layout.row()
        row.prop(self, 'inputSockets', text='Inputs')

    # Copy
    def copy(self, node):
        self.node_tree=node.node_tree.copy()

    # Free (when node is deleted)
    def free(self):
        bpy.data.node_groups.remove(self.node_tree, do_unlink=True)

from nodeitems_utils import NodeItem, register_node_categories, unregister_node_categories
# in blender2.80 use ShaderNodeCategory
from nodeitems_builtins import CompositorNodeCategory

def register():
    bpy.utils.register_class(MathsDynamic)
    newcatlist = [CompositorNodeCategory("SH_NEW_CUSTOM", "Custom Nodes", items=[NodeItem("MathsDynamic"),]),]
    register_node_categories("CUSTOM_NODES", newcatlist)

def unregister():
    unregister_node_categories("CUSTOM_NODES")
    bpy.utils.unregister_class(MathsDynamic)

# Attempt to unregister our class (in case it's already been registered before) and register it.
try :
    unregister()
except:
    pass
register() 

#classes = (
#    MathsDynamic,
#)
#register, unregister = bpy.utils.register_classes_factory(classes)