resource "local_file" "productos" {
    content = "Lista de productos para el mes proximo \n"
    filename = "productos.txt"
}