<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
%>
<!DOCTYPE HTML>
<html lang="en">
<head>
    <title>登陆-天天微学</title>
    <meta charset="utf-8">
    <style type="text/css">

        body {
            background-color: #326696;
            margin: 0px;
            overflow: hidden;
            font-family: Monospace;
            font-size: 13px;
            text-align: center;
            font-weight: bold;
            text-align: center;
        }

        a {
            color: #0078ff;
        }

        .login {
            width: 40%;
            height: 400px;
            background-color: rgba(255, 255, 255, 0.5);
            position: absolute;
            top: 15%;
            border-radius: 50%;
            left: 30%;
            border: solid #CCCCCC 1px;
        }

        .login-text {
            width: 200px;
            margin-top: 20%;
            border: solid #CCCCCC 1px;
        }
        .login-btn{
            width: 80%;
            margin-top: 30px;
            height: 50px;
            border-radius: 10px;
            background-color: cadetblue;
            margin-left: 10%;
            color: #FFFFFF;
            line-height: 50px;
            font-size: 20px;
            cursor: pointer;
        }
        .login-btn:hover{
            background-color: #CCCCCC;
        }

    </style>
</head>
<body>


<script type="text/javascript" src="<%=basePath%>/js/ThreeWebGL.js"></script>
<script type="text/javascript" src="<%=basePath%>/js/ThreeExtras.js"></script>

<script type="text/javascript" src="<%=basePath%>/js/Detector.js"></script>
<script type="text/javascript" src="<%=basePath%>/js/RequestAnimationFrame.js"></script>

<script id="vs" type="x-shader/x-vertex">

			varying vec2 vUv;

			void main() {

				vUv = uv;
				gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

			}



</script>

<script id="fs" type="x-shader/x-fragment">

			uniform sampler2D map;

			uniform vec3 fogColor;
			uniform float fogNear;
			uniform float fogFar;

			varying vec2 vUv;

			void main() {

				float depth = gl_FragCoord.z / gl_FragCoord.w;
				float fogFactor = smoothstep( fogNear, fogFar, depth );

				gl_FragColor = texture2D( map, vUv );
				gl_FragColor.w *= pow( gl_FragCoord.z, 20.0 );
				gl_FragColor = mix( gl_FragColor, vec4( fogColor, gl_FragColor.w ), fogFactor );

			}



</script>

<script type="text/javascript">

    if (!Detector.webgl) Detector.addGetWebGLMessage();

    // Bg gradient

    var canvas = document.createElement('canvas');
    canvas.width = 32;
    canvas.height = window.innerHeight;

    var context = canvas.getContext('2d');

    var gradient = context.createLinearGradient(0, 0, 0, canvas.height);
    gradient.addColorStop(0, "#1e4877");
    gradient.addColorStop(0.5, "#4584b4");

    context.fillStyle = gradient;
    context.fillRect(0, 0, canvas.width, canvas.height);

    document.body.style.background = 'url(' + canvas.toDataURL('image/png') + ')';

    // Clouds

    var container;
    var camera, scene, renderer, sky, mesh, geometry, material,
            i, h, color, colors = [], sprite, size, x, y, z;

    var mouseX = 0, mouseY = 0;
    var start_time = new Date().getTime();

    var windowHalfX = window.innerWidth / 2;
    var windowHalfY = window.innerHeight / 2;

    init();
    animate();

    function init() {

        container = document.createElement('div');
        document.body.appendChild(container);

        camera = new THREE.Camera(30, window.innerWidth / window.innerHeight, 1, 3000);
        camera.position.z = 6000;

        scene = new THREE.Scene();

        geometry = new THREE.Geometry();

        var texture = THREE.ImageUtils.loadTexture('<%=basePath%>/img/cms/cloud10.png');
        texture.magFilter = THREE.LinearMipMapLinearFilter;
        texture.minFilter = THREE.LinearMipMapLinearFilter;

        var fog = new THREE.Fog(0x4584b4, -100, 3000);

        material = new THREE.MeshShaderMaterial({

            uniforms: {

                "map": {type: "t", value: 2, texture: texture},
                "fogColor": {type: "c", value: fog.color},
                "fogNear": {type: "f", value: fog.near},
                "fogFar": {type: "f", value: fog.far}

            },
            vertexShader: document.getElementById('vs').textContent,
            fragmentShader: document.getElementById('fs').textContent,
            depthTest: false

        });

        var plane = new THREE.Mesh(new THREE.Plane(64, 64));

        for (i = 0; i < 8000; i++) {

            plane.position.x = Math.random() * 1000 - 500;
            plane.position.y = -Math.random() * Math.random() * 200 - 15;
            plane.position.z = i;
            plane.rotation.z = Math.random() * Math.PI;
            plane.scale.x = plane.scale.y = Math.random() * Math.random() * 1.5 + 0.5;

            GeometryUtils.merge(geometry, plane);

        }

        mesh = new THREE.Mesh(geometry, material);
        scene.addObject(mesh);

        mesh = new THREE.Mesh(geometry, material);
        mesh.position.z = -8000;
        scene.addObject(mesh);

        renderer = new THREE.WebGLRenderer({antialias: false});
        renderer.setSize(window.innerWidth, window.innerHeight);
        container.appendChild(renderer.domElement);

        document.addEventListener('mousemove', onDocumentMouseMove, false);
        window.addEventListener('resize', onWindowResize, false);

    }

    function onDocumentMouseMove(event) {

        mouseX = ( event.clientX - windowHalfX ) * 0.25;
        mouseY = ( event.clientY - windowHalfY ) * 0.15;

    }

    function onWindowResize(event) {

        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();

        renderer.setSize(window.innerWidth, window.innerHeight);

    }

    function animate() {

        requestAnimationFrame(animate);
        render();

    }

    function render() {

        position = ( ( new Date().getTime() - start_time ) * 0.03 ) % 8000;

        camera.position.x += ( mouseX - camera.target.position.x ) * 0.01;
        camera.position.y += ( -mouseY - camera.target.position.y ) * 0.01;
        camera.position.z = -position + 8000;

        camera.target.position.x = camera.position.x;
        camera.target.position.y = camera.position.y;
        camera.target.position.z = camera.position.z - 1000;

        renderer.render(scene, camera);

    }
    function doQYLogin(){
        window.location.href="https://qy.weixin.qq.com/cgi-bin/loginpage?corp_id=wxf54e1b5e0b62fa96&redirect_uri=http%3A%2F%2Fwww.wexue.top%2Fauth%2Flogin";
    }

</script>
<div class="login">
    <img class="login-text" src="<%=basePath%>/img/logo.png">
    <div class="login-btn" onclick="doQYLogin()">企业号授权登陆</div>
</div>
</body>
</html>
