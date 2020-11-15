using JuMP
using GLPK

m = Model(with_optimizer(GLPK.Optimizer))

# Number of nodes
n = 14
M = 100


# Cost of edges
cost = [M 0 0 1 1 0 1 1 1 1 1 1 1 1;
        0 M 1 0 1 1 1 1 1 1 1 1 0 1;
        0 1 M 1 1 1 1 0 1 1 1 1 1 0;
        1 0 1 M 1 1 0 0 1 1 1 1 1 1;
        1 1 1 1 M 1 1 1 0 0 0 1 1 1;
        0 1 1 1 1 M 0 1 1 1 1 1 1 1;
        1 1 1 0 1 0 M 1 1 0 1 1 1 1;
        1 1 0 0 1 1 1 M 0 1 1 1 1 1;
        1 1 1 1 0 1 1 0 M 1 1 1 1 1;
        1 1 1 1 0 1 0 1 1 M 1 0 1 1;
        1 1 1 1 0 1 1 1 1 1 M 0 0 1;
        1 1 1 1 1 1 1 1 1 0 0 M 1 0;
        1 0 1 1 1 1 1 1 1 1 0 1 M 0;
        1 1 0 1 1 1 1 1 1 1 1 0 0 M]


# Variable definition
@variable(m, x[1:n, 1:n], Bin)
@variable(m, u[1:n])

# Objective function
@objective(m, Min, sum(cost[i, j] * x[i, j] for i = 1:n for j = 1:n))

# Constraints - flow out of node
@constraint(m, oneout[i = 1:n], sum(x[i, j] for j = 1:n) == 1)
# Constraints - flow into node
@constraint(m, onein[j = 1:n], sum(x[i, j] for i = 1:n) == 1)

# Constraints - node order
for i = 1:n, j = 1:n
    if i != 1 && j != 1
        @constraint(m, u[i] - u[j] + 1 <= (n-1) * (1 - x[i, j]))
    end
end


# Constraints of alternating northern/southern seating order
# Northern Hemisphere
for i = [1,5,6,7,11,12,14], j = [1,5,6,7,11,12,14]
    @constraint(m, x[i,j] <= 0)
end

# Southern hemisphere
for i = [2,3,4,8,9,10,13], j = [2,3,4,8,9,10,13]
    @constraint(m, x[i,j] <= 0)
end

# Constraints bound on u
@constraint(m, u[1] == 1)




@constraint(m, oneposl[i = 2:n], u[i] >= 2)
@constraint(m, oneposu[i = 2:n], u[i] <= n)

optimize!(m)


# Print results
println("Objective Value: ", objective_value(m))
for i = 1:n, j = 1:n
    if JuMP.value(x[i, j]) > 1 - 1e-6
        println("Edge ", i, "-", j, " ", value(x[i, j]))
    end
end
