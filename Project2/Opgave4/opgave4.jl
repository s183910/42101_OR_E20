using JuMP
using GLPK
m = Model(with_optimizer(GLPK.Optimizer))
n=14
cost = [0 0 0 10 10 0 10 10 10 10 10 10 10 10; 0 0 10 0 10 10 10 10 10 10 10 10 0 10; 0 10 0 10 10 10 10 0 10 10 10 10 10 0;
        10 0 10 0 10 10 0 0 10 10 10 10 10 10; 10 10 10 10 0 10 10 10 0 0 0 10 10 10; 0 10 10 10 10 0 0 10 10 10 10 10 10 10;
10 10 10 0 10 0 0 10 10 0 10 10 10 10; 10 10 0 0 10 10 10 0 0 10 10 10 10 10 ; 10 10 10 10 0 10 10 0 0 10 10 10 10 10;
10 10 10 10 0 10 0 10 10 0 10 0 10 10 ; 10 10 10 10 0 10 10 10 10 10 0 0 0 10; 10 10 10 10 10 10 10 10 10 0 0 0 10 0 ;
10 0 10 10 10 10 10 10 10 10 0 10 0 0 ; 10 10 0 10 10 10 10 10 10 10 10 0 0 0]

# mutable struct Arc
#     from::Int64
#     to::Int64
#     cost::Int64
#     UB::Int64
# end

# arcs = [Arc(1,2,0,0), Arc(1,3,0,0), Arc(1,4,1,0), Arc(1,5,1,0), Arc(1,6,0,0), Arc(1,7,1,0), Arc(1,8,1,0), Arc(1,9,1,0), Arc(1,10,1,0),
# Arc(1,11,1,0), Arc(1,12,1,0), Arc(1,13,1,0), Arc(1,14,1,0), Arc(2,1,0,0), Arc(2,3,1,0), Arc(2,4,0,0), Arc(2,5,1,0), Arc(2,6,1,0),
# Arc(2,7,1,0), Arc(2,8,1,0), Arc(2,9,1,0), Arc(2,10,1,0), Arc(2,11,1,0), Arc(2,12,1,0), Arc(2,13,0,0), Arc(2,14,1,0), Arc(3,1,0,0),
# Arc(3,2,1,0), Arc(3,4,1,0), Arc(3,5,1,0), Arc(3,6,1,0), Arc(3,7,1,0), Arc(3,8,0,0), Arc(3,9,1,0), Arc(3,10,1,0), Arc(3,11,1,0),
# Arc(3,12,1,0),  Arc(3,13,1,0),  Arc(3,14,0,0), Arc(4,1,1,0), Arc(4,2,0,0), Arc(4,3,1,0), Arc(4,5,1,0), Arc(4,6,1,0), Arc(4,7,0,0),
# Arc(4,8,0,0), Arc(4,9,1,0), Arc(4,10,1,0), Arc(4,11,1,0), Arc(4,12,1,0), Arc(4,13,1,0), Arc(4,14,1,0), Arc(5,1,1,0), Arc(5,2,1,0),
# Arc(5,3,1,0), Arc(5,4,1,0), Arc(5,6,1,0), Arc(5,7,1,0), Arc(5,8,1,0), Arc(5,9,0,0), Arc(5,10,0,0), Arc(5,11,0,0), Arc(5,12,1,0),
# Arc(5,13,1,0), Arc(5,14,1,0), Arc(6,1,0,0), Arc(6,2,1,0), Arc(6,3,1,0), Arc(6,4,1,0), Arc(6,5,1,0), Arc(6,7,0,0), Arc(6,8,1,0),
# Arc(6,9,1,0), Arc(6,10,1,0), Arc(6,11,1,0), Arc(6,12,1,0), Arc(6,13,1,0), Arc(6,14,1,0), Arc(7,1,1,0), Arc(7,2,1,0), Arc(7,3,1,0),
# Arc(7,4,0,0), Arc(7,5,1,0), Arc(7,6,0,0), Arc(7,8,1,0), Arc(7,9,1,0), Arc(7,10,0,0), Arc(7,11,1,0), Arc(7,12,1,0), Arc(7,13,1,0),
# Arc(7,14,1,0), Arc(8,1,1,0), Arc(8,2,1,0), Arc(8,3,0,0), Arc(8,4,0,0), Arc(8,5,1,0), Arc(8,6,1,0), Arc(8,7,1,0), Arc(8,9,0,0),
# Arc(8,10,1,0), Arc(8,11,1,0), Arc(8,12,1,0), Arc(8,13,1,0), Arc(8,14,1,0), Arc(9,1,1,0), Arc(9,2,1,0), Arc(9,3,1,0), Arc(9,4,1,0),
# Arc(9,5,0,0), Arc(9,6,1,0), Arc(9,7,1,0), Arc(9,8,0,0), Arc(9,10,1,0), Arc(9,11,1,0), Arc(9,12,1,0), Arc(9,13,1,0), Arc(9,14,1,0),
# Arc(10,1,1,0), Arc(10,2,1,0), Arc(10,3,1,0), Arc(10,4,1,0), Arc(10,5,0,0), Arc(10,6,1,0), Arc(10,7,0,0), Arc(10,8,1,0), Arc(10,9,1,0),
# Arc(10,11,1,0), Arc(10,12,0,0), Arc(10,13,1,0), Arc(10,14,1,0), Arc(11,1,1,0), Arc(11,1,1,0), Arc(11,2,1,0), Arc(11,3,1,0), Arc(11,4,1,0),
# Arc(11,5,0,0), Arc(11,6,1,0), Arc(11,7,1,0), Arc(11,8,1,0), Arc(11,9,1,0), Arc(11,10,1,0), Arc(11,12,0,0), Arc(11,13,0,0), Arc(11,14,1,0),
# Arc(12,1,1,0), Arc(12,2,1,0), Arc(12,13,1,0), Arc(12,4,1,0), Arc(12,5,1,0),Arc(12,6,1,0),Arc(12,7,1,0),Arc(12,8,1,0),Arc(12,9,1,0), Arc(12,10,0,0),
# Arc(12,11,0,0),Arc(12,13,1,0), Arc(12,14,0,0), Arc(13,1,1,0), Arc(13,2,0,0), Arc(13,3,1,0),Arc(13,4,1,0), Arc(13,5,1,0), Arc(13,6,1,0),
# Arc(13,7,1,0), Arc(13,8,1,0), Arc(13,9,1,0), Arc(13,10,1,0), Arc(13,11,0,0), Arc(13,12,1,0),Arc(13,14,0,0),Arc(14,1,1,0), Arc(14,2,1,0),
# Arc(14,3,0,0),Arc(14,4,1,0), Arc(14,5,1,0), Arc(14,6,1,0), Arc(14,7,1,0), Arc(14,8,1,0), Arc(14,9,1,0), Arc(14,10,1,0), Arc(14,11,1,0),
# Arc(14,12,0,0), Arc(14,13,0,0)]


# for a in arcs
#     if a.UB > 0
#         @constraint(m, x[a] <= a.UB)
#     end
# end


#variable definition
@variable(m, x[1:n,1:n], Bin)
@variable(m, u[1:n])
#objective function
@objective(m, Min, sum(cost[i, j] * x[i,j] for i = 1:n for j = 1:n))
# constraints - flow out of node
@constraint(m, [i=1:n], sum(x[i,j] for j=1:n) == 1)
# constraints - flow into node
@constraint(m, [j=1:n], sum(x[i,j] for i=1:n) == 1)
# constraints - node order
for i=1:n, j=1:n
    if i != 1 && j!=1
        @constraint(m, u[i]-u[j]+(n-1)*x[i,j] <= (n-2))
    end
end
# constraints - bounds on u
@constraint(m, u[1]==1)
@constraint(m, [i=2:n], u[i]>=2)
@constraint(m, [i=2:n], u[i]<=14)
optimize!(m)
println("Objective Value: ", JuMP.objective_value(m))
for i=1:n, j=1:n
    if JuMP.value(x[i,j]) > 1-1e-6
        println("Edge ", i, "-", j, " ", JuMP.value(x[i,j]))
    end
end
