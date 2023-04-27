

const btnPredict = document.querySelector('#predict_btn');

const azure_endpoint = 'https://predict-decision.azurewebsites.net/api/predict?code=uHCiSektoav4la9hyR_40eLzUTEMuYOahek9T3jIYZYuAzFuFaSwbA==';
const local_endpoint = 'http://localhost:7071/api/Predict'

const predText = document.querySelector('#res_container');
const theForm = document.querySelector('#input-form');

const setValues = function(userInput){
    userInput.dispute_type = document.querySelector('#dispute_type').value;

    userInput.appl_identity = document.querySelector('#appl_identity').value;
    userInput.appl_age_range = document.querySelector('#appl_age_range').value;
    userInput.appl_income = document.querySelector('#appl_income').value;
    userInput.appl_gender_identity = document.querySelector('#appl_gender_identity').value;
    userInput.appl_province = document.querySelector('#appl_province').value;
    userInput.appl_has_lawyer = document.querySelector('#appl_has_lawyer').value;

    
    userInput.resp_identity = document.querySelector('#resp_identity').value;
    userInput.resp_age_range = document.querySelector('#resp_age_range').value;
    userInput.resp_income = document.querySelector('#resp_income').value;
    userInput.resp_gender_identity = document.querySelector('#resp_gender_identity').value;
    userInput.resp_province = document.querySelector('#resp_province').value;
    userInput.resp_has_lawyer = document.querySelector('#resp_has_lawyer').value;

    userInput.tm_identity = document.querySelector('#tm_identity').value;
    userInput.tm_age_range = document.querySelector('#tm_age_range').value;
    userInput.tm_gender_identity = document.querySelector('#tm_gender_identity').value;
    userInput.tm_province = document.querySelector('#tm_province').value;
}

async function getPrediction(userInputData){
    let response = await fetch(azure_endpoint, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(userInputData)
      });
    let data = await response.json();
    console.log(data);
    console.log(data.pred);
    raw_pred_value = data.pred;
    percentage = Math.round(raw_pred_value * 100)
    
    predText.textContent = `The probability of the judge or tribunal member ruling in favour of the applicant is ${percentage < 1.0 ? "less than 1" : percentage}%`;
    btnPredict.disabled = false;
    btnPredict.textContent = "Predict";
    return data;
}

btnPredict.addEventListener('click', function(e){
    let formValid = theForm.checkValidity();
    if(!formValid){
        theForm.reportValidity();
    }else{
        e.preventDefault();//prevent form from submitting
        predText.textContent = '';
        btnPredict.disabled = true;
        btnPredict.textContent = "Predicting...please wait";
        userInput = {};

        setValues(userInput);
        console.log("userInput: ",userInput);

        predictionRes = getPrediction(userInput);
        console.log("predictionRes",predictionRes);
    }
});