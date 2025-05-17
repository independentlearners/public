# Menghitung nilai faktorial

Program berikut menggambarkan fungsi untuk menghitung  
nilai faktorial dari suatu masukan bilangan, meminta pengguna untuk suatu bilangan, dan mencetak
nilai faktorialnya:

```lua
--defines a factorial function
	function fact(n)
	if n == 0 then
		return 1
		else
			return n * fact(n-1)
		end
	end

print('enter a number:')
a = io.read("*number") --membaca bilangan
print(fact(a))
```
