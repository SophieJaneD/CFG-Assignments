

// initializing lists and totsl cost variable
  const forages = ["pea flakes", "rose petals", "dried carrot", "dried parsnip", "marigold"];
  const shoppingBasket = [];
  let totalCost = 0;
  

// Display the available forages
  function displayForages() {
      const list = document.getElementById("forage-list");
      list.innerHTML = "";  // Clear the list before adding new items
  
// Add each forage type to the list
      for (let i = 0; i < forages.length; i++) {
          const listItem = document.createElement("li"); // Create <li> element
          listItem.textContent = forages[i]; // Set text
          list.appendChild(listItem); // Append to the list
      }
  }

    // Check is user input is valid, if it is add it to shopping basket and notify user, if not notify user 
  function checkAnswer() {
    const userAnswer = document.getElementById("answer1").value.trim().toLowerCase(); //formats user input for comparison with forages list itens
    const resultText = document.getElementById("result");
  
    if (forages.includes(userAnswer)) {
        shoppingBasket.push(userAnswer); // Add the selected forage to the shopping basket
        resultText.textContent = userAnswer + " added to basket!";
        resultText.style.color = "green"; 
        resultText.style.fontWeight = 800;
        totalCost = shoppingBasket.length *2;
        console.log("TOTAL COST: £" + totalCost);
        displayShoppingBasket(); // Update the shopping basket with new item
    } else if (userAnswer == "done") {
        totalCost = shoppingBasket.length * 2;
        resultText.textContent = `You have ${(shoppingBasket.length)} items in your basket costing £` + totalCost;
        resultText.style.color = "purple";
        document.getElementById("yes-no-container").style.display = "block"; //Ask for donation
       
    } else {
        resultText.textContent = "Not one of our products. Try again!";
        resultText.style.color = "red";  // Change text color to red
    }
  }

  function displayShoppingBasket() {
    const basketList = document.getElementById("shopping-basket-list");
    basketList.innerHTML = "";  // Clear the list before adding new items

    // Add each item in the shopping basket to the list
    for (let i = 0; i < shoppingBasket.length; i++) {
        const listItem = document.createElement("li"); // Create <li> element
        listItem.textContent = shoppingBasket[i]; // Set text
        basketList.appendChild(listItem); // Append to the list
    }
}



  function calculatePostage() {
    const resultText = document.getElementById("result");

    if (totalCost < 10) {
        resultText.innerHTML = `Delivery is £2.00. Your total is £${(shoppingBasket.length * 2 + 2).toFixed(2)}`;
        totalCost += 2;
        console.log("TOTAL COST: £" + totalCost);
    } else {
        resultText.innerHTML = `You qualify for free delivery! Your total is £${(shoppingBasket.length * 2).toFixed(2)}`;
    }
}

function handleYes() {
    totalCost++;
    const resultText = document.getElementById("result");
    resultText.innerHTML = "&#10084; Thank you for doing your part for bunkind &#10084;";
    alert("<br>Your new total is £" + totalCost);
    resultText.innerHTML += "<br>Proceed to the next page to calculate postage &#127970;";
    document.getElementById("postage-calculator").style.display = "block";
    console.log("TOTAL COST: £" + totalCost);
}

function handleNo() {
    const resultText = document.getElementById("result");
    resultText.innerHTML = "Maybe next time... &#128546;"; 
    resultText.innerHTML += "<br>Proceed to the next page to calculate postage &#127970;";
    document.getElementById("postage-calculator").style.display = "block";
    console.log("TOTAL COST: £" + totalCost);
}