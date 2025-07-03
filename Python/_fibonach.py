
n = 100000

result = [1, 2]

while 1:
    temp = result[-1] + result[-2]
    if temp <= n:
        result.append(temp)
    else:
        break

print(result)

# [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025]
