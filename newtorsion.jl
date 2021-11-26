

function read_bondline(top, vv, atom)
    r1 = zeros(Int64, 0)
    for i = 1:top.bondnum[vv]
        if top.bonda[vv][i] == atom
            append!(r1, top.bondb[vv][i])
        elseif top.bondb[vv][i] == atom
            append!(r1, top.bonda[vv][i])
        end
    end
    return r1
end

function get_torsions(cbox, top, aa, ab, at, bt, att, btt)

    torsatoma = zeros(Int64, 0)
    torsatomb = zeros(Int64, 0)
    torsatomc = zeros(Int64, 0)
    torsatomd = zeros(Int64, 0)
    torstype = zeros(Int64, 0)
    
    ta2 = zeros(Int64, 0)
    tb2 = zeros(Int64, 0)
    tc2= zeros(Int64, 0)
    td2= zeros(Int64, 0)
    
    va2 = zeros(Int64, 0)
    vb2 = zeros(Int64, 0)
    vc2 = zeros(Int64, 0)
    vd2 = zeros(Int64, 0)
    
    #j2 - j1 - aa - ab
    for i = 1:length(aa)
        a1 = read_bondline(top, at[i], att[i])
        for j1 in a1
            a2 = read_bondline(top, at[i], j1)
            for j2 in a2
                if j2 != att[i]
                    append!(torsatoma, j2 - att[i] + aa[i])
                    append!(torsatomb, j1 - att[i] + aa[i])
                    append!(torsatomc, aa[i])
                    append!(torsatomd, ab[i])
                    
                    append!(ta2, j2)
                    append!(tb2, j1)
                    append!(tc2, att[i])
                    append!(td2, btt[i])
                    
#                    append!(va2, 1)
#                    append!(vb2, 1)
#                    append!(vc2, 1)
#                    append!(vd2, 2)
                end
            end
        end
    end
    #j1 - aa - ab - k1
    for i = 1:length(aa)
         a1 = read_bondline(top, at[i], att[i])
         for j1 in a1
            b1 = read_bondline(top, bt[i], btt[i])
            for k1 in b1
                append!(torsatoma, j1 - att[i] + aa[i])
                append!(torsatomb, aa[i])
                append!(torsatomc, ab[i])
                append!(torsatomd, k1 - btt[i] + ab[i])
                
                append!(ta2, j1)
                append!(tb2, att[i])
                append!(tc2, btt[i])
                append!(td2, k1)
                
#                append!(va2, 1)
#                append!(vb2, 1)
#                append!(vc2, 2)
#                append!(vd2, 2)
            end
         end
    end
    
    # aa - ab - k1 - k2
    for i = 1:length(aa)
         b1 = read_bondline(top, bt[i], btt[i])
         for k1 in b1
            b2 = read_bondline(top, bt[i], k1)
            for k2 in b2
                if k2 != btt[i]
                    append!(torsatoma, aa[i])
                    append!(torsatomb, ab[i])
                    append!(torsatomc, k1 - btt[i] + ab[i])
                    append!(torsatomd, k2 - btt[i] + ab[i])
                    
                    append!(ta2, att[i])
                    append!(tb2, btt[i])
                    append!(tc2, k1)
                    append!(td2, k2)
                    
#                append!(va2, 1)
#                append!(vb2, 2)
#                append!(vc2, 2)
#                append!(vd2, 2)
                end
            end
         end
    end
    
    fileId = open("newtorsion", "w")
    for i = 1:length(torsatoma)
        println(fileId,torsatoma[i], "\t", torsatomb[i], "\t", torsatomc[i], "\t", torsatomd[i], "\t", ta2[i], "\t", tb2[i], "\t", tc2[i], "\t", td2[i])
    end
    close(fileId)
    
#    println(at[1])
#    println(att[1])
#    println(read_bondline(top, at[1], att[1]))
#    println(read_bondline(top, 1, 32))
    
    return [torsatoma, torsatomb, torsatomc, torsatomd, ta2, tb2, tc2, td2]
end
