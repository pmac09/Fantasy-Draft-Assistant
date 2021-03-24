styles <- "

#fieldLayout {
  height:704px; 
  background-size:100% 100%; 
  background-image:url('./fieldImage.jpg');
}

#onFieldLayout {
  height:100%; 
  width:79%;
  float:left;
}

#offFieldLayout {
  height:100%; 
  margin-left:79%;
}

.positionalLine {
  height:25%;
  width:100%;
  display:flex;
  flex-direction:column;
  justify-content:space-around;
  text-align:center;
}

#benchLine {
  height:50%;
  width:100%;
  position: relative;
  top: 25%;
}

.playerCell{
  height:35px;
  max-width:150px;
  margin:5px;
  overflow: hidden;
  background:LightGrey;
  border-style:solid;
  border-width:1px;
  text-align:left;
}

.playerCell .teamLogo {
  float:left;
}

.playerCell .teamLogo img{
  height:35px;
  width:35px;
}

.playerCell .playerInfo {
  margin-left: 37px;
}

.playerCell .playerInfo .playerName {
  font-size: 13px;
  font-weight: bold;
  line-height: 160%;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.playerCell .playerInfo .playerPos {
  font-size: 10.5px;
  line-height: 80%;
}

.playerItem {
  display: block;
  width:100%;
}

.playerItem .teamLogo {
  float:left;
}

.playerItem .teamLogo img{
  height:34px;
  width:34px;
}

.playerItem .playerName {
  font-size: 17px;
  margin-left: 40px;
  padding: 5px 0;
  height:100%;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.playerItem .playerPos {
  overflow: hidden;
  position: relative;
  display: inline-block;
  float:right;
}


"