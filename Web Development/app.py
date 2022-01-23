from flask import Flask, render_template, request, redirect, url_for, session
from flask_session import Session
from datetime import date

import mysql.connector
import joblib

app = Flask(__name__)

app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)


logindb = mysql.connector.connect(host='localhost', user = 'root', password = 'root',database = "userLogin")
registerdb = mysql.connector.connect(host='localhost', user = 'root', password = 'root',database = "userLogin")
coviddb = mysql.connector.connect(host='localhost', user = 'root', password = 'root',database = "userLogin")
breastdb = mysql.connector.connect(host='localhost', user = 'root', password = 'root',database = "userLogin")


loginCursor = logindb.cursor()
registerCursor = registerdb.cursor()
covidCursor = coviddb.cursor()
breastCursor = breastdb.cursor()

selQueryUID = "select * from userInfo"
loginCursor.execute(selQueryUID)
userids = loginCursor.fetchall()


today = date.today()


@app.route('/')
def home():
    if not session.get('idd'):
        return redirect('/login')
    return render_template('home.html')

@app.route('/logout')
def logout():
    session['idd'] = None
    return redirect('/')



@app.route('/register',methods=['POST', 'GET'])
def register():
    if request.method =='POST':
        fname = request.form.get('fnamed')
        lname = request.form.get('lnamed')
        contact = request.form.get('ctd')
        age = request.form.get('aged')
        gender = request.form.get('genderd')
        bg = request.form.get('bgd')
        city = request.form.get('cityd')
        email = request.form.get('idd')
        pas = request.form.get('passd')

        sqlQueryInsert = "insert into resgiterUser(fname, lname, contact, age, gender, bg, city, email) values(%s,%s,%s,%s,%s,%s,%s,%s)"
        value = (fname,lname,contact,age,gender,bg,city,email)
        registerCursor.execute(sqlQueryInsert, value)
        registerdb.commit()

        selQueryLogin = "insert into userInfo (uid,pass) values(%s, %s)"
        loginValue = (email,pas)
        loginCursor.execute(selQueryLogin,loginValue)
        logindb.commit()


        return render_template('home.html')
    else:
        return render_template('regiter.html')

@app.route('/login' , methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        uid = request.form.get('idd')
        passw = request.form.get('passd')

        loginCursor.execute(selQueryUID)
        userids = loginCursor.fetchall()

        for i in userids:
            if uid == i[0] and passw == i[1]:
                session["idd"] = request.form.get('idd')
                return redirect('/')
        else:
            return "enter valid crediential"
    else:
        return render_template('login.html')




@app.route('/covid', methods=['POST', 'GET'])
def covid():
    if request.method == 'POST':
        fever = request.form.get('fever')
        cough = request.form.get('coughd')
        headAche = request.form.get('headached')
        soreThroat = request.form.get('sorethroatd')
        breathing = request.form.get('breathingd')

        if cough == 'yes':
            coughc = 1
        elif cough == 'no':
            coughc = 0

        if fever == 'yes':
            feverc = 1
        elif fever =='no':
            feverc = 0

        if breathing == 'yes':
            breathingc = 1
        elif breathing == 'no':
            breathingc = 0

        if headAche == 'yes':
            headAchec = 1
        elif headAche == 'no':
            headAchec = 0

        if soreThroat == 'yes':
            soreThroatc = 1
        elif soreThroat == 'no':
            soreThroatc = 0

        model = joblib.load('DT_model.sav')
        model_ip = [[coughc, feverc, soreThroatc, breathingc, headAchec]]
        model_op = model.predict(model_ip)

        if model_op == 1:
            resultDB = "Positive"
            result_show = 'you many have chances of Covid 19, we''ll suggest you to do covid test physically.'
        else:
            resultDB = "Negative"
            result_show = 'you are safe from Covid 19, Please take care of yourself in this Covid 19 situation'

        sqlQueryCovid = "insert into covid(email, fever, cough, breathing, head, sore, result, testDate) values(%s,%s,%s,%s,%s,%s,%s,%s)"
        emailC = session['idd']
        valueC = (emailC,fever, cough, breathing, headAche, soreThroat, resultDB, today)
        covidCursor.execute(sqlQueryCovid, valueC)
        coviddb.commit()

        return render_template('covid.html', result = result_show)

    else:
        return render_template('covid.html')

@app.route('/breast', methods=['POST', 'GET'])
def breast():
    if request.method == 'POST':
        texture_mean = request.form.get('TMd')
        concavity_mean = request.form.get('CMd')
        symmetry_mean = request.form.get('smd')
        textureSE = request.form.get('TSed')
        areaSE = request.form.get('Ased')
        fractalD = request.form.get('FDSed')


        model3 = joblib.load('ExtraTreesClassifier1.sav')
        model_ip3 = [[texture_mean,concavity_mean,symmetry_mean,textureSE,areaSE,fractalD]]
        model_op3 = model3.predict(model_ip3)

        if model_op3 == 1:
            resultB = "Positive"
            result_show3 = 'you many have chances of Breast cancer, we''ll suggest you to perform diagnosis'
        else:
            resultB = "Negative"
            result_show3 = 'you are safe from Breast Cancer.'

        sqlQueryBreast = "insert into breast(email,tm,cm,sm,ts,ase,fd,result,testDate) values(%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        emailB = session['idd']
        valueB = (emailB,texture_mean, concavity_mean, symmetry_mean, textureSE, areaSE, fractalD, resultB, today)
        breastCursor.execute(sqlQueryBreast, valueB)
        breastdb.commit()

        return render_template('breast.html', result3 = result_show3)

    else:
        return render_template('breast.html')


@app.route('/heart', methods=['POST', 'GET'])
def heart():
    if request.method == 'POST':
        age = request.form.get('aged')
        gender = request.form.get('genderd')
        cp = request.form.get('chestpaind')
        bp = request.form.get('bpd')
        maxHR = request.form.get('heartrated')
        execinc = request.form.get('breathingd')
        stDep = request.form.get('STd')
        novessel = request.form.get('cad')
        thal = request.form.get('thald')

        if gender == 'male':
            gender = 1
        elif gender == 'feamle':
            gender = 0

        if cp == 'typical angina':
            cp = 0
        elif cp == 'atypical angina':
            cp = 1
        elif cp == 'non-anginal pain':
            cp = 2
        elif cp == 'asymptomatic':
            cp = 3

        if thal == 'normal':
            thal = 1
        elif thal == 'fixed defect':
            thal = 2
        elif thal == 'reversable defect':
            thal = 3


        if execinc == 'yes':
            execinc = 1
        elif execinc == 'no':
            execinc = 0



        model2 = joblib.load('heartlinear.sav')
        model_ip2= [[age,gender,cp,bp,maxHR,execinc,stDep,novessel,thal]]
        model_op2 = model2.predict(model_ip2)

        if model_op2 == 1:
            result_show2 = 'you many have chances of Covid 19, we''ll suggest you to do covid test physically.'
        else:
            result_show2 = 'you are safe from Covid 19, Please take care of yourself in this Covid 19 sitution'

        return render_template('heart.html', result2 = result_show2)

    else:
        return render_template('heart.html')


@app.route('/history')
def history():
    selQueryDetail = "select * from resgiterUser where email = %s"
    covidDetail = "select * from covid where email = %s"
    breastDetail = "select * from breast where email = %s"

    sessionName = session['idd']
    value = (sessionName,)

    registerCursor.execute(selQueryDetail, value)
    covidCursor.execute(covidDetail, value)
    breastCursor.execute(breastDetail, value)

    userDetail = registerCursor.fetchall()

    covidDetailOP = covidCursor.fetchall()

    breastDetailOP = breastCursor.fetchall()

    for i in userDetail:

        if i[7] == sessionName:
            return render_template('history.html', userDetails=i, covidDetails = covidDetailOP, breastDetails = breastDetailOP)
        else:
            return render_template('history.html', userDetails = "Could not fetch the detail")
    return render_template('history.html')

if __name__ == '__main__':
    app.run(debug=True)
