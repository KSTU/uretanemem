

function bonding(box, aold, anew, bold, bnew, rcut, filename)

    bond_num = Array{AbstractArray}(undef, box.natom)
    check_num = zeros(Int64, box.natom)
    
    atoma = zeros(Int64,0)
    atomb = zeros(Int64,0)
    rab = zeros(Float64,0)
    
    fileId = open(filename, "w")
    for i = 1:box.natom
        bond_num[i] = Array{Int64}(undef, 0)
        if box.atoms[i].aname == aold  #check atoms
            for j = 1:box.natom
                if j != i   #check not o himself
                    #check distances
                    dx = abs(box.atoms[i].x - box.atoms[j].x)
                    dy = abs(box.atoms[i].y - box.atoms[j].y)
                    dz = abs(box.atoms[i].z - box.atoms[j].z)
                    if dx > box.bx/2
                        dx = box.bx - dx
                    end
                    if dy > box.by/2
                        dy = box.by - dy
                    end
                    if dz > box.bz/2
                        dz = box.bz - dz
                    end
                    r = sqrt(dx^2 + dy^2 + dz^2)
                    if r < rcut
                        if box.atoms[i].aname == aold && box.atoms[j].aname == bold
                            box.atoms[i].aname = anew
                            box.atoms[j].aname = bnew
                            append!(atoma, i)
                            append!(atomb, j)
                            append!(rab, r)
                            #println("a ", box.atoms[i].aname, " b ", box.atoms[j].aname, " r ", r)
                        end
                        
                    end
                    
                end
            end
        end
    end
    
    fileId = open("newbonds", "w")
    for i = 1:length(atoma)
        println(fileId, atoma[i], "\t", atomb[i],"\t", box.atoms[atoma[i]].aname, "\t", box.atoms[atomb[i]].aname)
    end
    close(fileId)
    
    println(atoma)
    println(atomb)
#    println(rab)
    return [atoma, atomb]
end
