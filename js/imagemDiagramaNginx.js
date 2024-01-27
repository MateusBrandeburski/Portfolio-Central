function ajustarImagem() {
    var largura = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
    var imagem = document.getElementById('imagemDiagramaNginx');

    if (largura < 768) { 
        imagem.src = 'images/diagramaNginxCelular.png'; 
    } else {
        imagem.src = 'images/diagrama-nginx-2.png'; 
    }
}

window.onload = ajustarImagem;
window.onresize = ajustarImagem;

