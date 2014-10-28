class LectorEscritor
	attr_accessor :ruta1
	attr_accessor :ruta2
	attr_accessor :datos
	attr_accessor :theta
	attr_accessor :alfa
	attr_accessor :iteraciones
	attr_accessor :tolerancia
	attr_accessor :n
	attr_accessor :m
	attr_accessor :guardar
	
	#METODO PARA LEER ARCHIVOS
	def leer_archivo
		datos = []
		theta = []
		indice = 0
		prueba_split = ''

		#  Lectura del primer archivo
		if @ruta1.nil?
			puts "No hay archivo"
		else
			File.open("#{@ruta1}",'r') do |f1|
				while linea = f1.gets
					prueba_split = linea.split(/,/)
					prueba_split.each do |dato|
						datos[indice] = dato
						indice = indice + 1
					end
					datos[indice] = 'y'
					indice = indice + 1
				end
			end
			n = prueba_split.length
		end

		#  Lectura del segundo archivo
		indice = n
		if @ruta2.nil?
			puts "No hay archivo"
		else
			File.open("#{@ruta2}",'r') do |f2|
				while linea = f2.gets
					datos[indice] = linea
					indice = indice + n + 1
				end
			end
		end
		
		# Ingreso de theta's inicales con valor aleatorio
		indice = 0
		while indice < n
			theta[indice] = rand() * 6 - 3
			indice+=1
		end
		
		@datos = datos
		@theta = theta
		@n = n
		@m = datos.length/(n+1)
		
		operar()
	end

	def operar
		guardar = ""
		iterar = 0
		var_costo = 0
		while iterar < iteraciones
			var_costo = costo()
			if var_costo > tolerancia
				guardar = guardar + "#{var_costo}\n"
				repetir()
			else
				guardar = guardar + "#{var_costo}\n"
				break
			end
			iterar += 1
		end
		if iteraciones == iterar
			guardar = guardar + "#{var_costo}\n"
		end
		
		crear_archivo(guardar)
	end
	
	def costo
		cost = 0
		sumatoria = 0
		control = 0
		m.times do |i|
			sumatoria = hipotesis(i) - @datos[i*4+n].to_f
			control = sumatoria**2
			cost += control
		end
		cost = (1.0/(2*m))*cost
		return cost
	end
	
	def repetir
		repite=0;
        sumatoria=0;
        nueva_theta = []
        
		n.times do |h|
			m.times do |i|
				sumatoria = hipotesis(i) - @datos[(i*(n+1))+n].to_f
				repite += sumatoria*@datos[h+((n+1)*i)].to_f
			end
			repite = @theta[h].to_f - (alfa/m*repite)
			nueva_theta[h] = repite
			repite = 0
		end
        
		n.times do |j|
			print "©#{j}: #{@theta[j]}\t"
			@theta[j]=nueva_theta[j]
		end
		print "\n"
	end
	
	def hipotesis(index)
		hipot = 0
		n.times do |i|
			hipot += @theta[i].to_f * @datos[i + (index*4)].to_f
		end
		
		return hipot
	end
	
	def imprime_final(var_costo)
		save = ""
		puts "Costo Final:\t"+var_costo.to_s+"\n"
		n.times do |j|
			print "©#{j}: #{@theta[j]}\t"
		end
		print "\n\n"
	end

	def crear_archivo(salida)
		File.open('costFunction.txt', 'w') do |f2|
			f2.puts salida
		end
	end

end


if __FILE__ == $0
  arch = LectorEscritor.new
  arch.alfa = 0.01
  arch.iteraciones = 1000
  arch.tolerancia = 0.00001
  #arch.ruta1 = "C:/Users/rick/Desktop/[IA1]Practica1_200516231/xs.csv"
  #arch.ruta2 = "C:/Users/rick/Desktop/[IA1]Practica1_200516231/ys.csv"
  arch.ruta1 = "xs.csv"
  arch.ruta2 = "ys.csv"
  arch.leer_archivo
end