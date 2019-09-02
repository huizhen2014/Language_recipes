###linux mail 

##发邮件
#mail -s "This is the title" huizhen_2014@163.com < Content.txt

#or 

#mail -s "This is the title" huizhen_2014@163.com 
#This is the content
#EOF ##ctl D

##匿名
#mail -s "This is a anonymous email" -r "anonymous@mail.com" huizhen_2014@163.com < content.txt

##附件
#mail -s "This is a email with appendent files" -a appended_files.txt huizhen_2014@163.com < content.txt

##抄送， 所有收件人均可看到
#mail -s "This is a email with copy to addresses" -c name_1@163.com,name_2@163.com,name_3@163.com huizhen_2014@163.com < content.txt

##暗送邮件, 他人看不到
#mail -s "This is a email without seeing by everyone" -b name_1@163.com,name_2@163.com,name_3@163.com huizhen_2014@163.com < content.txt
