function get_version(cbox, top, aa, ab)
    atype = Array{Int64}(undef, length(aa))
    btype = Array{Int64}(undef, length(aa))
    anum = Array{Int64}(undef, length(aa))
    bnum = Array{Int64}(undef, length(aa))
    for i = 1:length(aa)
        #get current vvo
        ca = 0
        nmin = 1
        for j = 1:top.cvvo
            nmax = nmin + top.atomnum[j] * top.molnum[j]
            #println("nmin ", nmin, " nmax ", nmax)
            if aa[i] >= nmin && aa[i] < nmax
                ca = j
            end
            nmin += top.atomnum[j] * top.molnum[j]
        end
        nsum = 0 
        if ca > 1
            for j =1:ca-1
                nsum += top.atomnum[j] * top.molnum[j]
            end
        end
        caa = (aa[i] - nsum) % top.atomnum[ca]
        if caa == 0 
            caa = top.atomnum[ca]
        end
        atype[i] = ca
        anum[i] = caa
        #
        ca = 0
        nmin = 1
        for j = 1:top.cvvo
            nmax = nmin + top.atomnum[j] * top.molnum[j]
            #println("nmin ", nmin, " nmax ", nmax)
            if ab[i] >= nmin && ab[i] < nmax
                ca = j
            end
            nmin += top.atomnum[j] * top.molnum[j]
        end
        nsum = 0 
        if ca > 1
            for j =1:ca-1
                nsum += top.atomnum[j] * top.molnum[j]
            end
        end
        caa = (ab[i] - nsum) % top.atomnum[ca]
        if caa == 0 
            caa = top.atomnum[ca]
        end
        btype[i] = ca
        bnum[i] = caa
    end
    fileId = open("newver", "w")
    for i = 1:length(atype)
        println(fileId, atype[i], "\t", btype[i], "\t", anum[i], "\t", bnum[i])
    end
    close(fileId)
    return [atype, btype, anum, bnum]
end

function get_angles(cbox, top, aa, ab)
    anatoma = zeros(Int64, 0)
    anatomb = zeros(Int64, 0)
    anatomc = zeros(Int64, 0)
    antype = zeros(Int64, 0)
    anatypea = zeros(Int64, 0)
    anatypeb = zeros(Int64, 0)
    att = zeros(Int64, 0)
    btt = zeros(Int64, 0)
    
    for i = 1:length(aa)
        #get current vvo
        ca = 0
        nmin = 1
        for j = 1:top.cvvo
            nmax = nmin + top.atomnum[j] * top.molnum[j]
            #println("nmin ", nmin, " nmax ", nmax)
            if aa[i] >= nmin && aa[i] < nmax
                ca = j
            end
            nmin += top.atomnum[j] * top.molnum[j]
        end
        nsum = 0 
        if ca > 1
            for j =1:ca-1
                nsum += top.atomnum[j] * top.molnum[j]
            end
        end
        caa = (aa[i] - nsum) % top.atomnum[ca]
        if caa == 0 
            caa = top.atomnum[ca]
        end
        #println("n a ", a, " vo ", ca, " caa ", caa)
        for j = 1:top.bondnum[ca]
            if top.bonda[ca][j] == caa
                append!(anatoma, aa[i] - caa + top.bondb[ca][j])
                append!(anatomb, aa[i])
                append!(anatomc, ab[i])
                append!(antype, top.bondtype[ca][j])
                append!(anatypea, ca)
                append!(att, caa)
            elseif top.bondb[ca][j] == caa
                append!(anatoma, aa[i] - caa + top.bonda[ca][j])
                append!(anatomb, aa[i])
                append!(anatomc, ab[i])
                append!(antype, top.bondtype[ca][j])
                append!(anatypea, ca)
                append!(att, caa)
            end
        end
    end
    
    for i = 1:length(ab)
        #get current vvo
        ca = 0
        nmin = 1
        for j = 1:top.cvvo
            nmax = nmin + top.atomnum[j] * top.molnum[j]
            #println("nmin ", nmin, " nmax ", nmax)
            if ab[i] >= nmin && ab[i] < nmax
                ca = j
            end
            nmin += top.atomnum[j] * top.molnum[j]
        end
        nsum = 0 
        if ca > 1
            for j = 1:ca-1
                nsum += top.atomnum[j] * top.molnum[j]
            end
        end
        caa = (ab[i] - nsum) % top.atomnum[ca]
        if caa == 0 
            caa = top.atomnum[ca]
        end
        #println("n a ", a, " vo ", ca, " caa ", caa)
        for j = 1:top.bondnum[ca]
            if top.bonda[ca][j] == caa
                append!(anatoma, ab[i] - caa + top.bondb[ca][j])
                append!(anatomb, ab[i])
                append!(anatomc, aa[i])
                append!(antype, top.bondtype[ca][j])
                append!(anatypeb, ca)
                append!(btt, caa)
            elseif top.bondb[ca][j] == caa
                append!(anatoma, ab[i] - caa + top.bonda[ca][j])
                append!(anatomb, ab[i])
                append!(anatomc, aa[i])
                append!(antype, top.bondtype[ca][j])
                append!(anatypeb, ca)
                append!(btt, caa)
            end
        end
    end
    fileId = open("newangles", "w")
    for i = 1:length(anatoma)
        println(fileId, anatoma[i], "\t",anatomb[i], "\t", anatomc[i], "\t", antype[i])
    end
    close(fileId)
    
    
    return [anatoma, anatomb, anatomc, antype]
end
