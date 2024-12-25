set tasks to {"sudo chflags -Rv schg /Users/hehuiqi/Desktop/1tmp/xh_city.json"}

do shell script tasks  with prompt "需要您授权才能继续操作" with administrator privileges
return "success"
