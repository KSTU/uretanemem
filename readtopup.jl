
function read_top_up(filename)
    tnamea = Array{String}(undef, 100)
    tnameb = Array{String}(undef, 100)
    tnamec = Array{String}(undef, 100)
    tnamed = Array{String}(undef, 100)
    ttype = Array{Int64}(undef, 0)
    
    fileId = open(filename, "r")
    nlines = countlines(fileId)
    seekstart(fileId)
    reading = 0
    #sek numbers of molecules and names
    id = 0
    for i = 1:nlines
        cline = readline(fileId)
        if length(split(cline,"[")) > 1
            between = split(cline,"[")[2]
            between = split(between,"]")[1]
            between = strip(between)
            #println("|", between, "|")
            if cmp(between, "dihedraltypes") == 0
                global reading = 1
            else
                global reading = 0
            end
        else
            if reading == 1
                if length(split(strip(cline),";")[1]) > 3
                    id += 1 
#                    append!(tnamea, split(strip(cline))[1])
#                    append!(tnameb, split(strip(cline))[2])
#                    append!(tnamec, split(strip(cline))[3])
#                    append!(tnamed, split(strip(cline))[4])
                    tnamea[id] = split(strip(cline))[1]
                    tnameb[id] = split(strip(cline))[2]
                    tnamec[id] = split(strip(cline))[3]
                    tnamed[id] = split(strip(cline))[4]
                    append!(ttype, parse(Int64, split(strip(cline))[5]))
                    #println(split(strip(cline))[1])
                end
            end
        end
    end
#    for i = 1:size(ttype,1)
#        println(tnamea[i], "  ", tnameb[i], "  ", tnamec[i], "  ", tnamed[i], "  ", ttype[i])
#    end
#    println(tnamea)
    
    close(fileId)
    
    return [tnamea, tnameb, tnamec, tnamed, ttype]
end
