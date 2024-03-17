extends Control


func gcd2(a: int, b: int) -> int:
	if a == 0: return b
	return gcd2(b % a, a)

func gcd(arr: Array[int]) -> int:
	var result = arr[0]
	for i in arr.size():
		result = gcd2(arr[i], result)
		
		if result == 1: return 1
	
	return result
