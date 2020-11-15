using JuMP
using GLPK
m = Model(with_optimizer(GLPK.Optimizer))
n=6

return_procent = [0.057 0.068 0.047 0.054 0.039 0.041]
total_investment = 8850000

@variable(m, x[1:n]>=0)
@variable(m, y[1:n], Bin)
@objective(m,  Max, sum(return_procent[i]*x[i] for i=1:n))

@constraint(m, [i=1:n], return_procent[i]*x[i] >= 40000*y[i])
@constraint(m, [i=1:n], (return_procent[i]*x[i]) <= 250000*y[i])


@constraint(m, x[1]+x[3]+x[4]<=0.4*total_investment)
@constraint(m, x[3]+x[5]+x[6]==0.5*total_investment)


optimize!(m)
println("Objective Value: ", objective_value(m)) #633205.0
println("x-values = ", value.(x)) #[3.54e6, 3.676470588235294e6, 0.0, 0.0, 0.0, 4.425e6]
