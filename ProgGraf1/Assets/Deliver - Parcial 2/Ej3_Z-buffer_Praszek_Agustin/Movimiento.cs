using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movimiento : MonoBehaviour
{
[Header("Configuración")]
    [Tooltip("Distancia que se va a mover desde su punto inicial")]
    public Vector3 distancia = new Vector3(5f, 0f, 0f); 
    
    [Tooltip("Qué tan rápido va y viene")]
    public float velocidad = 1f;

    private Vector3 puntoInicial;

    void Start()
    {
        // Guarda la posición donde pusiste la esfera al principio
        puntoInicial = transform.position; 
    }

    void Update()
    {
        // Mathf.PingPong crea un valor que sube a 1 y baja a 0 constantemente
        float tiempo = Mathf.PingPong(Time.time * velocidad, 1f);
        
        // Calcula cuál es el punto B sumando la distancia al inicio
        Vector3 puntoFinal = puntoInicial + distancia;
        
        // Mueve la esfera suavemente entre el punto A y el B
        transform.position = Vector3.Lerp(puntoInicial, puntoFinal, tiempo);
    }
}
