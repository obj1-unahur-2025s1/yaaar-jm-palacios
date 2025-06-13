class BarcoPirata {
  const tripulacion = []
  var mision
  const capacidad

  method agregarTripulacion(unPirata){
    if (unPirata.esUtil(mision) and self.tieneCapacidad()){tripulacion.add(unPirata)}
  }
  method tieneCapacidad() = capacidad > self.cantidadTripulacion()
  method tripulacion() = tripulacion
  method cambioDeMision(nuevaMsion){}
  method cantidadTripulacion() = tripulacion.size()
  method nivelDeOcupacion() = (self.cantidadTripulacion()/capacidad)*100 
  method puedeAceptarMision() = self.nivelDeOcupacion() >= 90 
  method algunTripulanteTieneUnItem(unItem) = tripulacion.any({p => p.contineItem(unItem)})
  method puedeSerSaqueado(unPirata) = unPirata.pasadoDeGrog()
  method esVulnerable(unBarco) = unBarco.cantidadTripulacion()/2 >= self.cantidadTripulacion()
  method todosPasadosDeGrog() = tripulacion.all({p =>p.pasadoDeGrog()})
  method tirpulacionNoCalifica(unaMision) = tripulacion.filter({p => not unaMision.requisitosPirata(p)})
  method cambiarMision(nuevaMision){
    mision = nuevaMision
    tripulacion.removeAll(self.tirpulacionNoCalifica(nuevaMision))}
  method anclarEnCiudad(unaCiudad) {
    tripulacion.forEach({p => p.tomarUnTrago()})
    tripulacion.forEach({p =>p.gastarDinero(1)})
    tripulacion.remove({self.elMasBorracho()})
    unaCiudad.sumarUnHabitante()
  } 
  method elMasBorracho() = tripulacion.max({p => p.nivelDeEbriedad()})
  method esTemible() = mision.puedeCompletarlaMision(self) 

   
    
}

class Piratas {
  var ebriedad
  var dinero
  const objetos =[]

  method agregarObjetos(unaLista){objetos.addAll(unaLista)}   
  method nivelDeEbriedad() = ebriedad
  method tieneMenosDinero(unaCantidad) = dinero <= 5  
  method nivelDeEbridadMayor(unaCantidad) = ebriedad >= unaCantidad
  method pasadoDeGrog() = ebriedad >= 90
  method tomarUnTrago(){ebriedad = (ebriedad + 5).mim(100)}
  method gastarDinero(unMonto) {dinero = (dinero - unMonto).max(0)}
  method esUtil(unaMision) = unaMision.requisitos(self)
  method contineItem(unItem) = objetos.contains(unItem) 
  method tieneAlMenos(unaCant) = objetos.size() >= unaCant
  method seAnimaA(unObjetivo) = unObjetivo.puedeSerSaqueado(self)

  
}
class Mision {
  method puedeCompletarlaMision(unBarco) = unBarco.puedeAceptarMision()
  
}
class BusquedaDelTesoro inherits Mision {
  
  method requisitosPirata(unPirata){
    return (unPirata.objetos().contains('brujula') or 
    unPirata.objetos().contains('mapa') or unPirata.objetos().contains('botella de grog'))
    and unPirata.tieneMenosDinero(5)
  }
  method requisitosBarcoAdicional(unBarco) =  unBarco.algunTripulanteTieneUnItem('llave') 
  override method puedeCompletarlaMision(unBarco) = super(unBarco) and self.requisitosBarcoAdicional(unBarco)
}
class ConvertirseEnLeyenda inherits Mision {
 const itemObligatorio  

   method requisitosPirata(unPirata){
    return (unPirata.tieneAlMenos(10)) and unPirata.contieneItem(itemObligatorio)
  }
   
}
class Saqueo inherits  Mision {
  const objetivo
  method requisitosPirata(unPirata) {
    return  unPirata.tieneMenosDinero(monedasDeterminadas.valor())
    and unPirata.seAnimaA(objetivo)}
  method requisitosBarco(unBarco) = true
  
}
object monedasDeterminadas {
  var property valor = 5  
}
class CiudadCostera {
  var habitantes
  method puedeSerSaqueado(unPirata) = unPirata.nivelDeEbridadMayor(50)
  method esVulnerable(unBarco) = (unBarco.cantidadTripulacion() *0.4 >= habitantes) or unBarco.todosPasadosDeGrog()
  method sumarUnHabitante() {habitantes +=1}
  
}