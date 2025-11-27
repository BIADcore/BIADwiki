#--------------------------------------------------------------------------------------
# Move this example to biadwiki.org and delete file
#--------------------------------------------------------------------------------------
require(BIADconnect)
conn  <-  init.conn()
#--------------------------------------------------------------------------------------#--------------------------------------------------------------------------------------
x <- get.relatives(table.name = 'Sites', primary.value = 'S10671') 

x # look at the data

# look at direct relationships (tree) above or below
require(data.tree)
tree.down <- FromListSimple(x[[1]]$down)
tree.up <- FromListSimple(x[[1]]$up)

# print the results as a list
print(tree.down)
print(tree.up)

# show the results as a plot
plot(tree.down)
plot(tree.up)
#--------------------------------------------------------------------------------------
disconnect()
#--------------------------------------------------------------------------------------

