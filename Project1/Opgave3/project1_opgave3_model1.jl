##  Project 1
# Opgave 3
# Model 1

A=[
0 0 0 4 5 0 0 0 0 0;
0 0 0 0 0 0 0 0 0 0;
3 0 0 0 0 9 0 8 0 9;
0 0 8 0 5 0 0 0 0 0;
0 0 0 0 0 0 0 0 7 0;
0 0 0 0 0 0 0 0 3 0;
8 1 0 0 0 0 0 0 1 0;
0 0 0 3 0 0 0 0 0 5;
7 0 0 0 0 0 0 0 0 6;
0 0 0 0 0 0 7 0 0 0]
# The process of A in order to get the right input for the
# min cost flow model is done and seen as the vector of acrs here:
mutable struct Arc
    from::Int64
    to::Int64
    cost::Int64
    UB::Int64
end
arcs = [Arc(9,10,6,0), Arc(9,1,7,0), Arc(5,9,7,0), Arc(6,9,3,0), Arc(1,4,4,0), Arc(1,5,5,0), Arc(3,1,3,0), Arc(3,6,9,0), Arc(3,8,8,0), Arc(3,10,9,0), Arc(4,3,8,0), Arc(4,5,5,0), Arc(7,2,1,0),Arc(7,1,8,0), Arc(8,10,5,0), Arc(10,7,7,0), Arc(8,4,3,0)]

m=10 #Number of nodes
demands = [-30, -30, -50, 250, -20, -30, -30, -40, 0, -20]

using JuMP, GLPK
model1 = Model(with_optimizer(GLPK.Optimizer))


## Warehouse in node 4 calculations

@variable(model1, x[arcs]>=0)
@objective(model1, Min, sum(a.cost*x[a] for a in arcs)+1000)
@constraint(model1, [i=1:m], sum(x[a] for a in arcs if a.from==i) - sum(x[a] for a in arcs if a.to==i) == demands[i] )


for a in arcs
    if a.UB > 0
        @constraint(model1, x[a] <= a.UB)
    end
end

print(model1)
optimize!(model1)
println("Objective value: ", JuMP.objective_value(model1))
for a in arcs
    println("Flow on arc (", a.from,",",a.to,") is ", JuMP.value.(x[a]))
end


# Her er der en kommentar for tester
