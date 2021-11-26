#creat polyuretane membranes
include("readgro.jl")
include("readtop.jl")
include("near.jl")
include("get_coordination.jl")

include("newangles.jl")
include("newtorsion.jl")
include("topwrite.jl")
include("growrite.jl")

include("readtopup.jl")
#new version

cbox = readgro("test.gro")
vv = readtop("box.top")

#rbond = bonding(cbox, "uCu", "uCu", "mOal", "uOe", 0.2, "results")
rbond = bonding(cbox, "mOal", "uOe","uCu", "uCu", 0.2, "results")

#get_co_number(cbox, "uCu", "mOal", "uCu")
#get_co_number(cbox, "mOal", "uCu", "mOal")
addangles = get_angles(cbox, vv, rbond[1], rbond[2])
bversion = get_version(cbox, vv, rbond[1], rbond[2])

addtorsion = get_torsions(cbox, vv, rbond[1], rbond[2], bversion[1], bversion[2], bversion[3], bversion[4])
tup = read_top_up("box.top")
 
top_write("box.top", "outbox.top", vv, tup, rbond, addangles, addtorsion, cbox)
growrite("outbox.gro", cbox)

#println("added angles ", addangles)
#for i = 1:length(addtorsion[1])
#    println("added torsion ", addtorsion[1][i], " ", addtorsion[2][i], " ", addtorsion[3][i], " ", addtorsion[4][i])
#end
#println(vv.torsionb)
#println(vv.torsionc)
#println(vv.torsiond)
