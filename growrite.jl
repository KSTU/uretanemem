using Printf

function growrite(filename, box)
    fileId = open(filename, "w")
    println(fileId, "cretmeme 2 generated")
    println(fileId, box.natom)
    for i=1:box.natom
        @printf(fileId,"%5d%5s%5s%5d%8.3f%8.3f%8.3f%8.4f%8.4f%8.4f\n", 1, "MEM", box.atoms[i].aname, i, box.atoms[i].x, box.atoms[i].y, box.atoms[i].z, 0.0, 0.0, 0.0)
    end
    println(fileId, "   ", box.bx, "   ", box.by, "   ", box.bz)
    close(fileId)
end
