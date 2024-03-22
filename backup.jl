function dp (T)
    Q = zeros(61, 3, 10, 2) #60 points, 3 dices, 10 turns, 2 actions

    #Construct the value function for each state at each time
    V = zeros(61, 3, 10)

    P = zeros(61, 3, 10, 2, 61) #60 points, 3 dices, 10 turns, 2 actions, 60 points 
    for p in 0:60
        for d in 1:3
            for t in 1:10
                for a in 0:1
                    if d + a <= 3
                        law = law_max(d + a)
                        for p_prime in 0:60
                            P[p + 1, d, t, a + 1, p_prime + 1] = pdf(law, p_prime - p + 5 * a)
                        end
                    end
                end
            end
        end
    end
    policy_markov = zeros(61, 3, 10)
        for t in 10:-1:1
            for s in 0:60
                for d in 1:3
                    V[s + 1, d, t] = -100000
                    for a in 0:1
                        Q[s + 1, d, t, a + 1] = 0
                        if d + a <= 3 #we assure that we can't have more than 3 dices
                            for s_prime in 0:60
                                Q[s + 1, d, t, a + 1] += P[s + 1, d, t, a + 1, s_prime + 1] * (s_prime + 1 + V[s_prime + 1, d + a, t ])
                            end
                            if Q[s + 1, d, t, a + 1] > V[s + 1, d, t]
                                V[s + 1, d, t] = Q[s + 1, d, t, a + 1]
                                policy_markov[s + 1, d, t] = a
                            end
                        end
                    end
                end
            end
        end
        policy_markov = round.(Int, policy_markov)
        return policy_markov
end