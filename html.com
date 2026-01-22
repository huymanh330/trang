<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>3 Cánh Cửa Tri Thức</title>
<style>
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(#7ec850, #c8f7c5);
    overflow: hidden;
}
.screen {
    display: none;
    width: 100vw;
    height: 100vh;
}
.active {
    display: flex;
}
.center {
    justify-content: center;
    align-items: center;
    flex-direction: column;
}
.doors {
    display: flex;
    gap: 40px;
}
.door {
    width: 150px;
    height: 260px;
    background: linear-gradient(#8b5a2b, #c68642);
    border-radius: 15px;
    box-shadow: 0 10px 20px rgba(0,0,0,.3);
    cursor: pointer;
    font-size: 22px;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: transform .3s;
}
.door:hover {
    transform: scale(1.1);
}
.question-box {
    background: rgba(255,255,255,.95);
    padding: 25px;
    width: 70%;
    border-radius: 20px;
    box-shadow: 0 10px 25px rgba(0,0,0,.3);
}
.answers button {
    display: block;
    width: 100%;
    margin: 8px 0;
    padding: 10px;
    font-size: 16px;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    background: #4caf50;
    color: white;
}
.answers button:hover {
    background: #388e3c;
}
.timer {
    font-weight: bold;
    color: red;
    margin-bottom: 10px;
}
.result {
    font-size: 22px;
    background: white;
    padding: 30px;
    border-radius: 20px;
}
.flowers {
    position: absolute;
    bottom: 0;
    width: 100%;
    height: 150px;
    background: url('https://i.imgur.com/6Zb9YJ6.png') repeat-x;
}
</style>
</head>

<body>

<div id="start" class="screen active center">
    <h1>🌸 Chọn Một Cánh Cửa 🌸</h1>
    <div class="doors">
        <div class="door" onclick="startQuestion()">Cửa 1</div>
        <div class="door" onclick="startQuestion()">Cửa 2</div>
        <div class="door" onclick="startQuestion()">Cửa 3</div>
    </div>
</div>

<div id="quiz" class="screen center">
    <div class="question-box">
        <div class="timer">⏱️ Thời gian: <span id="time">60</span>s</div>
        <h3 id="question"></h3>
        <div class="answers" id="answers"></div>
    </div>
</div>

<div id="end" class="screen center">
    <div class="result" id="result"></div>
</div>

<div class="flowers"></div>

<script>
const questions = [
{
q:"Câu 7: Có bao nhiêu cách đi từ A đến D?",
a:["A. 32","B. 125","C. 122","D. 137"],
c:"B"
},
{
q:"Câu 8: Hùng có bao nhiêu cách chọn đường?",
a:["A. 5","B. 8","C. 13","D. 40"],
c:"D"
},
{
q:"Câu 9: Có bao nhiêu số tự nhiên gồm 4 chữ số khác nhau?",
a:["A. 360","B. 26","C. 189","D. 180"],
c:"A"
},
{
q:"Câu 10: Lập được bao nhiêu số chẵn 4 chữ số khác nhau?",
a:["A. 120","B. 200","C. 156","D. 240"],
c:"C"
},
{
q:"Câu 11: Có bao nhiêu số lẻ 4 chữ số khác nhau?",
a:["A. 720","B. 1470","C. 210","D. 750"],
c:"A"
},
{
q:"Câu 12: Có bao nhiêu số chia hết cho 5?",
a:["A. 136","B. 128","C. 256","D. 1458"],
c:"A"
}
];

let index = 0;
let score = 0;
let timer;

function startQuestion(){
    document.getElementById("start").classList.remove("active");
    document.getElementById("quiz").classList.add("active");
    loadQuestion();
}

function loadQuestion(){
    if(index >= questions.length){
        endGame();
        return;
    }
    let time = 60;
    document.getElementById("time").innerText = time;
    timer = setInterval(()=>{
        time--;
        document.getElementById("time").innerText = time;
        if(time <= 0){
            clearInterval(timer);
            index++;
            document.getElementById("quiz").classList.remove("active");
            document.getElementById("start").classList.add("active");
        }
    },1000);

    document.getElementById("question").innerText = questions[index].q;
    let html = "";
    questions[index].a.forEach(ans=>{
        html += `<button onclick="choose('${ans[0]}')">${ans}</button>`;
    });
    document.getElementById("answers").innerHTML = html;
}

function choose(letter){
    clearInterval(timer);
    if(letter === questions[index].c) score++;
    index++;
    document.getElementById("quiz").classList.remove("active");
    document.getElementById("start").classList.add("active");
}

function endGame(){
    document.getElementById("quiz").classList.remove("active");
    document.getElementById("end").classList.add("active");
    document.getElementById("result").innerHTML = `
        🎉 Hoàn thành bài!<br><br>
        ✅ Số câu đúng: <b>${score}/6</b><br>
        📌 Đáp án đúng: <b>BDACAA</b>
    `;
}
</script>

</body>
</html>
