## Photorama 

Photorama es una aplicación iOS que permite explorar y visualizar fotos desde la API de Flickr. La app permite alternar entre fotos interesantes y fotos recientes, mostrando la colección de imágenes en un flujo sencillo y navegable mediante gestos.

### Características 

- Visualización de fotos interesantes y recientes desde Flickr 

- Navegación de fotos mediante toque de pantalla.

- Soporte para multiples categorías de fotos (interesting/ recent).

- Gestión de la descarga y almacenamiento temporal de imágenes. 

### Arquitectura 

Photorama esta implementada siguiendo una arquitectura MVC(Model-View-Controller):

#### · Model: 

Photo: Representa cada foto de la API

PhotoStore: Maneja la descarga de fotos, abstrayendo la interacción con la API. 

#### · View: 

PhotosViewController: controla la interfaz, muestra las imágenes y gestiona la interacción del usuario. 

UIImageView: usada para mostrar la foto actual. 

UISegmentedControl: permite alternar entre tipos de fotos. 

#### · Controller: 

Gestiona la comunicación entre PhotoStore y la interfaz(PhotosViewController).

Maneja la lógica de selección de categoría y la actualización de la UI. 

### Tecnologías y frameworks 

Lenguaje: Swift

Framework: UIKit 

Gestos: UITapGestureRecognizer para navegar entre fotos. 

Concurrencia: DispatchQueue para actualizar la UI desde callbacks de red. 

Networking: URLSession para consumir la API de Flickr. 
