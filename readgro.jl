mutable struct atoms
    aname::String
    mname::String
    x::Float64
    y::Float64
    z::Float64
#    vx::Float64
#    vy::Float64
#    vz::Float64
end


mutable struct box
    atoms::AbstractArray
    bx::Float64
    by::Float64
    bz::Float64
    natom::Int64
end

function empty_atom()
    return atoms("aname", "mname", 0.0, 0.0, 0.0)
end

function empty_box()
    return box([],0.0, 0.0, 0.0, 0)
end

function readgro(filename)
    fileId = open(filename)
    tempstring = readline(fileId)
    box = empty_box()
    box.natom = parse(Int64, readline(fileId))
    
    box.atoms = Array{atoms}(undef, box.natom)
    for i=1:box.natom
        cline = readline(fileId)
        box.atoms[i] = empty_atom()
        box.atoms[i].x = parse(Float64, cline[21:28])
        box.atoms[i].y = parse(Float64, cline[29:36])
        box.atoms[i].z = parse(Float64, cline[37:44])
        box.atoms[i].aname = strip(cline[10:15])
        #println("aname ", box.atoms[i].aname, "  x  ", box.atoms[i].x, "  y   ", box.atoms[i].y, "  z  ", box.atoms[i].z)
#        box.atoms[i].vx = parse(Float64, cline[45:52])
#        box.atoms[i].vx = parse(Float64, cline[53:60])
#        box.atoms[i].vx = parse(Float64, cline[61:68])
    end
    cline = readline(fileId)
    box.bx = parse(Float64, split(cline)[1])
    box.by = parse(Float64, split(cline)[2])
    box.bz = parse(Float64, split(cline)[3])
    close(fileId)
    
    println(box.natom)
    println("data from $(filename) readed")
    
    return box
end
