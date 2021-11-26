#get ccordination 


function get_co_number(box, a, b, filename)

    fileId = open(filename, "w")
    for i = 1:box.natom
        if box.atoms[i].aname == a  #check atoms
            near = 0
            rmin = 0.3
            for j = 1:box.natom
                if box.atoms[j].aname == b  #check atoms
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
                    if r < 0.3
                        #println(fileId, a, "\t", b, "\t", r)
                        near += 1
                        if r<rmin
                            rmin = r
                        end
                    end
                end
            end
            println(fileId, a, "  ", near, "  ", rmin)
        end
    end
    close(fileId)
end
