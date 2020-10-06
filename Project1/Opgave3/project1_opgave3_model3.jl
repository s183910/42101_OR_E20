##  Project 1
# Opgave 3
# Model 3

## Warehouses in both node 4 and 9 calculations
mutable struct Arc
    from::Int64
    to::Int64
    cost::Int64
    UB::Int64
end
m=10 #antal nodes being costumers and warehouses
arcs = [Arc(9,10,6,0), Arc(9,1,7,0), Arc(5,9,7,0), Arc(6,9,3,0), Arc(1,4,4,0), Arc(1,5,5,0), Arc(3,1,3,0), Arc(3,6,9,0), Arc(3,8,8,0), Arc(3,10,9,0), Arc(4,3,8,0), Arc(4,5,5,0), Arc(7,2,1,0),Arc(7,1,8,0), Arc(8,10,5,0), Arc(10,7,7,0), Arc(8,4,3,0)]

demands = [-30, -30, -50, 125, -20, -30, -30, -40, 125, -20]

using JuMP, GLPK
model3 = Model(with_optimizer(GLPK.Optimizer))

@variable(model3,x[arcs]>=0)
@objective(model3, Min, sum(a.cost*x[a] for a in arcs)+2000)
@constraint(model3,[i=1:m], sum(x[a] for a in arcs if a.from==i) -sum(x[a] for a in arcs if a.to==i) == demands[i] )

for a in arcs
    if a.UB > 0
        @constraint(model3, x[a] <= a.UB)
    end
end

print(model3)
optimize!(model3)
println("Objective value: ", JuMP.objective_value(model3))
for a in arcs
    println("Flow on arc (", a.from,",",a.to,") is ", JuMP.value.(x[a]))
end
