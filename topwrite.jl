
function gan(top, anum)
    ca = 0
    nmin = 1
    for j = 1:top.cvvo
        nmax = nmin + top.atomnum[j] * top.molnum[j]
        #println("nmin ", nmin, " nmax ", nmax)
        if anum >= nmin && anum < nmax
            ca = j
        end
        nmin += top.atomnum[j] * top.molnum[j]
    end
    
    return ca
end


function top_write(inputfile, filename, top, tup, abond, aangle, atorsion, box)
    infileId = open(inputfile, "r")
    fileId = open(filename, "w")
    
    nlines = countlines(infileId)
    seekstart(infileId)
    global reading = 1
    for i = 1:nlines
        cline = readline(infileId)
        if length(split(cline,"[")) > 1
            println(cline)
            if cmp(br_read(cline,"[","]"), "moleculetype") == 0
                global reading = 0
            end
        end
        if reading == 1
            println(fileId, cline)
        end
    end
    close(infileId)
    println(fileId, "[ moleculetype ] \nMEM    4")
    
    println(fileId, "[ atoms ]")
    id = 0
    for i = 1:top.cvvo
        for j = 1:top.molnum[i]
            for k = 1:top.atomnum[i]
                id += 1
                println(fileId, id,"  ", box.atoms[id].aname, "  1  MEM  ", box.atoms[id].aname, "  1  ", top.atomq[i][k], "  ", top.atommass[i][k])
            end
        end
    end
#    for i = 1:box.natom
#        println(fileId, i, "   ", )
#    end
    
    
    println(fileId, "\n[ bonds ]")
    btype = 0
    cmol = 0
    for i = 1:top.cvvo
        for j = 1:top.molnum[i]
            for k = 1:top.bondnum[i]
#                for t = 1:top.bondnum[i]
#                    if (abond[1][i] == top.bonda[i][t] && abond[2][i] == top.bondb[i][t]) || (abond[1][i] == top.bondb[i][t] && abond[2][i] == top.bonda[i][t])
#                        btype = top.bondtype[i][t]
#                    end
#                end
                println(fileId, cmol + top.bonda[i][k], "   ", cmol + top.bondb[i][k], "   ", top.bondtype[i][k])
            end
            cmol += top.atomnum[i]
        end
    end
    
    for i = 1:length(abond)
#        for j = 1:top.bondnum[i]
#            if (abond[1][i] == top.bonda[i][j] && abond[2][i] == top.bondb[i][j]) || (abond[1][i] == top.bondb[i][j] && abond[2][i] == top.bonda[i][j])
#                btype = top.bondtype[i][t]
#            end
#        end
        println(fileId, abond[1][i], "  ", abond[2][i], "  ", 1)
    end
    
    println(fileId, "\n[ pairs ]\n[ angles ]")
    cmol = 0
    for i = 1:top.cvvo
        for j = 1:top.molnum[i]
            for k = 1:top.anglenum[i]
                println(fileId, cmol + top.anglea[i][k], "   ", cmol + top.angleb[i][k], "   ", cmol + top.anglec[i][k], "   1")
            end
            cmol += top.atomnum[i]
        end
    end
    
    for i = 1:length(aangle[1])
        println(fileId, aangle[1][i], "  ", aangle[2][i], "  ", aangle[3][i], "  1")
    end
    
    println(fileId, "\n[ dihedrals ]")
    cmol = 0
    for i = 1:top.cvvo
        for j = 1:top.molnum[i]
            for k = 1:top.torsionnum[i]
                println(fileId, cmol + top.torsiona[i][k], "   ", cmol + top.torsionb[i][k], "   ", cmol + top.torsionc[i][k], "   ", cmol + top.torsiond[i][k], "   ", top.torsiontype[i][k])
            end
            cmol += top.atomnum[i]
        end
    end
    
    
    for i = 1:length(atorsion[1])
        ctype = 0
        for j = 1:length(tup[5])
#            if tup[1][j] == top.atomname[gan(top, atorsion[1][i])][atorsion[5][i]] && tup[2][j] == top.atomname[gan(top, atorsion[2][i])][atorsion[6][i]] && tup[3][j] == top.atomname[gan(top, atorsion[3][i])][atorsion[7][i]] && tup[4][j] == top.atomname[gan(top, atorsion[4][i])][atorsion[8][i]]
#                ctype = tup[5][j]
#            end
#            if tup[1][j] == top.atomname[gan(top, atorsion[4][i])][atorsion[8][i]] && tup[2][j] == top.atomname[gan(top, atorsion[3][i])][atorsion[7][i]] && tup[3][j] == top.atomname[gan(top, atorsion[1][i])][atorsion[6][i]] && tup[4][j] == top.atomname[gan(top, atorsion[1][i])][atorsion[5][i]]
#                ctype = tup[5][j]
#            end
            if tup[1][j] == box.atoms[atorsion[1][i]].aname && tup[2][j] == box.atoms[atorsion[2][i]].aname && tup[3][j] == box.atoms[atorsion[3][i]].aname && tup[4][j] == box.atoms[atorsion[4][i]].aname
                ctype = tup[5][j]
            end

#            if tup[gan(top, atorsion[1][i])][j] == top.atomname[atorsion[5][i]]
#                ctype = tup[5][j]
#            end
            #println(top.atomname[gan(top, atorsion[1][i])][atorsion[5][i]])
            #println(top.atomname[gan(top, atorsion[2][i])][atorsion[6][i]])
            
        end
        println(fileId, atorsion[1][i], "  ", atorsion[2][i], "  ", atorsion[3][i], "  ", atorsion[4][i], "  ", ctype)
    end
    
    println(fileId, "\n[ system ]\ncreatmem 2  generated\n[ molecules ]\nMEM    1")
    
    close(fileId)
    
end
