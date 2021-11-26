mutable struct topology
    cvvo::Int64
    molnum::AbstractArray
    
    atomnum::AbstractArray  #numbers of atoms
    bondnum::AbstractArray  #numbers of bonds
    anglenum::AbstractArray #numbers of angles
    torsionnum::AbstractArray   #numbers of orsion angle
    
    atomname::AbstractArray
    atomff::AbstractArray
    atomq::AbstractArray
    atommass::AbstractArray
    
    bonda::AbstractArray
    bondb::AbstractArray
    bondtype::AbstractArray
    
    anglea::AbstractArray
    angleb::AbstractArray
    anglec::AbstractArray
    angletype::AbstractArray
    
    torsiona::AbstractArray
    torsionb::AbstractArray
    torsionc::AbstractArray
    torsiond::AbstractArray
    torsiontype::AbstractArray
end

function new_top()
    topology(1,[1,1], [1,1], [1,1], [1,1])
end

function br_read(str,br1,br2)
    bt = split(strip(str),br1)[2]
    bt = strip(split(bt,br2)[1])
    return bt
end


function readtop(filename)

    fileId = open(filename)
    #molecules in sysem
    inpmol = Array{Int64}(undef,0)


    nlines = countlines(fileId)
    seekstart(fileId)
    reading = 0
    #sek numbers of molecules and names
    for i = 1:nlines
        cline = readline(fileId)
        if length(split(cline,"[")) > 1
            between = split(cline,"[")[2]
            between = split(between,"]")[1]
            between = strip(between)
            #println("|", between, "|")
            if cmp(between, "molecules") == 0
                global reading = 1
            else
                global reading = 0
            end
        else
            if reading == 1
                if length(split(strip(cline),";")[1]) > 3
                    append!(inpmol, parse(Int64, split(strip(cline))[2]))
                    println(split(strip(cline))[1])
                end
            end
        end
    end
    inpname = Array{String}(undef, length(inpmol))

    #sek numbers of molecules and names
    seekstart(fileId)
    reading = 0
    cvvo = 0
    for i = 1:nlines
        cline = readline(fileId)
        if length(split(cline,"[")) > 1
            if cmp(br_read(cline,"[","]"), "molecules") == 0
                global reading = 1
            else
                global reading = 0
            end
        else
            if reading == 1
                if length(split(strip(cline),";")[1]) > 3
                    cvvo += 1
                    inpname[cvvo] = split(strip(cline))[1]
                end
            end
        end
    end

    # read atoms
    atomnum = zeros(Int64, cvvo)
    bondnum = zeros(Int64, cvvo)
    anglenum = zeros(Int64, cvvo)
    torsionnum = zeros(Int64, cvvo)
    
    atomname = Array{AbstractArray}(undef, cvvo)
    atomff = Array{AbstractArray}(undef, cvvo)
    atomq = Array{AbstractArray}(undef, cvvo)
    atommass = Array{AbstractArray}(undef, cvvo)
    
    bonda = Array{AbstractArray}(undef, cvvo)
    bondb = Array{AbstractArray}(undef, cvvo)
    bondtype = Array{AbstractArray}(undef, cvvo)
    
    anglea = Array{AbstractArray}(undef, cvvo)
    angleb = Array{AbstractArray}(undef, cvvo)
    anglec = Array{AbstractArray}(undef, cvvo)
    angletype = Array{AbstractArray}(undef, cvvo)
    
    torsiona = Array{AbstractArray}(undef, cvvo)
    torsionb = Array{AbstractArray}(undef, cvvo)
    torsionc = Array{AbstractArray}(undef, cvvo)
    torsiond = Array{AbstractArray}(undef, cvvo)
    torsiontype = Array{AbstractArray}(undef, cvvo)
    
    for vnum = 1:cvvo
        seekstart(fileId)
        reading = 0
        reading2 = 0
        reading3 = 0
        reading4 = 0
        reading5 = 0
        for i = 1:nlines
            cline = readline(fileId)
            if length(split(cline,"[")) > 1
                if cmp(br_read(cline,"[","]"), "moleculetype") == 0
                    curpos = position(fileId)
                    cline = readline(fileId)
                    if split(strip(cline))[1] == inpname[vnum]
                        reading = 1
                    else
                        reading = 0
                    end
                else
                    if cmp(br_read(cline,"[","]"), "atoms") == 0
                        reading2 = 1
                    else
                        reading2 = 0
                    end
                    if cmp(br_read(cline,"[","]"), "bonds") == 0
                        reading3 = 1
                    else
                        reading3 = 0
                    end
                    if cmp(br_read(cline,"[","]"), "angles") == 0
                        reading4 = 1
                    else
                        reading4 = 0
                    end
                    if cmp(br_read(cline,"[","]"), "dihedrals") == 0
                        reading5 = 1
                    else
                        reading5 = 0
                    end
                end
            else
                if reading == 1
                    if reading2 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            atomnum[vnum] += 1
                        end
                    end
                    #-----------------
                    if reading3 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            bondnum[vnum] += 1
                        end
                    end
                    #-----------------
                    if reading4 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            anglenum[vnum] += 1
                        end
                    end
                    #-----------------
                    if reading5 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            torsionnum[vnum] += 1
                        end
                    end
                    #
                end
            end
        end
        #read data
        seekstart(fileId)
        reading = 0
        reading2 = 0
        reading3 = 0
        reading4 = 0
        reading5 = 0
        
        atomname[vnum] = Array{String}(undef, atomnum[vnum])
        atomff[vnum] = Array{String}(undef, atomnum[vnum])
        atomq[vnum] = Array{Float64}(undef, atomnum[vnum])
        atommass[vnum] = Array{Float64}(undef, atomnum[vnum])
        
        bonda[vnum] = Array{Int64}(undef, bondnum[vnum])
        bondb[vnum] = Array{Int64}(undef, bondnum[vnum])
        bondtype[vnum] = Array{Int64}(undef, bondnum[vnum])
        
        anglea[vnum] = Array{Int64}(undef, anglenum[vnum])
        angleb[vnum] = Array{Int64}(undef, anglenum[vnum])
        anglec[vnum] = Array{Int64}(undef, anglenum[vnum])
        angletype[vnum] = Array{Int64}(undef, anglenum[vnum])
        
        torsiona[vnum] = Array{Int64}(undef, torsionnum[vnum])
        torsionb[vnum] = Array{Int64}(undef, torsionnum[vnum])
        torsionc[vnum] = Array{Int64}(undef, torsionnum[vnum])
        torsiond[vnum] = Array{Int64}(undef, torsionnum[vnum])
        torsiontype[vnum] = Array{Int64}(undef, torsionnum[vnum])
        
        aid = 0
        bid = 0
        anid = 0
        tid = 0
        for i = 1:nlines
            cline = readline(fileId)
            if length(split(cline,"[")) > 1
                if cmp(br_read(cline,"[","]"), "moleculetype") == 0
                    curpos = position(fileId)
                    cline = readline(fileId)
                    if split(strip(cline))[1] == inpname[vnum]
                        reading = 1
                    else
                        reading = 0
                    end
                else
                    if cmp(br_read(cline,"[","]"), "atoms") == 0
                        reading2 = 1
                    else
                        reading2 = 0
                    end
                    if cmp(br_read(cline,"[","]"), "bonds") == 0
                        reading3 = 1
                    else
                        reading3 = 0
                    end
                    if cmp(br_read(cline,"[","]"), "angles") == 0
                        reading4 = 1
                    else
                        reading4 = 0
                    end
                    if cmp(br_read(cline,"[","]"), "dihedrals") == 0
                        reading5 = 1
                    else
                        reading5 = 0
                    end
                end
            else
                if reading == 1
                    if reading2 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            aid += 1
                            atomname[vnum][aid] = split(cline)[2]
                            atomff[vnum][aid] = split(cline)[5]
                            atomq[vnum][aid] = parse(Float64, split(cline)[7])
                            atommass[vnum][aid] = parse(Float64, split(cline)[8])
                        end
                    end
                    #-----------------
                    if reading3 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            bid += 1
                            bonda[vnum][bid] = parse(Int64, split(cline)[1])
                            bondb[vnum][bid] = parse(Int64, split(cline)[2])
                            bondtype[vnum][bid] = parse(Int64, split(cline)[3])
                        end
                    end
                    #-----------------
                    if reading4 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            anid += 1
                            anglea[vnum][anid] = parse(Int64, split(cline)[1])
                            angleb[vnum][anid] = parse(Int64, split(cline)[2])
                            anglec[vnum][anid] = parse(Int64, split(cline)[3])
                            angletype[vnum][anid] = parse(Int64, split(cline)[4])
                        end
                    end
                    #-----------------
                    if reading5 == 1
                        if length(split(strip(cline),";")[1]) > 3
                            tid += 1
                            torsiona[vnum][tid] = parse(Int64, split(cline)[1])
                            torsionb[vnum][tid] = parse(Int64, split(cline)[2])
                            torsionc[vnum][tid] = parse(Int64, split(cline)[3])
                            torsiond[vnum][tid] = parse(Int64, split(cline)[4])
                            torsiontype[vnum][tid] = parse(Int64, split(cline)[5])
                        end
                    end
                    #
                end
            end
        end
    end
    
    println("inpmol ", inpmol)
    
    
    close(fileId)
#    println(atomnum)
#    println(bondnum)
#    println(anglenum)
#    println(torsionnum)
    
    return topology(cvvo,
    inpmol,
    atomnum, bondnum, anglenum, torsionnum, atomname,
    atomff,
    atomq,
    atommass,
    bonda,
    bondb,
    bondtype,
    anglea,
    angleb,
    anglec,
    angletype,
    torsiona,
    torsionb,
    torsionc,
    torsiond,
    torsiontype)
    
    
end
