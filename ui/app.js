let items;
let ownitems;
let playerMoney;

$(document).keyup(function(e) {
  if (e.key === "Escape") {

    $.post('https://ds-marketplace/escape')
 }
});

function closeNui(close) {

  $.post('https://ds-marketplace/escape')
}

function backNui(name) {

  fetch("https://ds-marketplace/backnui", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      businessType: name,
    }),
  });
}

function removeItem(id, item, quantity) {

  fetch("https://ds-marketplace/removeitem", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      id, item, quantity
    }),
  });

}

function myListings() {

  const element = document.querySelector('.wrapper');
  element.innerHTML = "";

  for (let i = 0; i < ownitems.length; i++) {
    const info = ownitems[i];

    element.innerHTML += `
    <div class="box">

    <div class="label">${info.label} (${info.quantity}x)</div>
    <img class="img" src= "nui://qb-inventory/html/images/${info.image}" alt="">
    <div class="pricetag">$${info.price}</div>


    <button class="unlist" onclick="removeItem('${info.id}', '${info.item}', '${info.quantity}')">
          <span class="fas fa-trash"></span>
          Remove Listing
    </button>

  </div>
    `

  }

    const element2 = document.querySelector('.sidebar');
      element2.innerHTML += `
      <div class="back" onclick="backNui('close')">Back</div>
      `

}

function createListing() {

  const element = document.querySelector('.wrapper');
  element.innerHTML = "";
    element.innerHTML += `
    <div class="listingBox">
    <div class="listingheader">List A Item</div>

    <form id="quantityForm">

    <input type="text" id="item" name="item" minlength="1" maxlength="50" placeholder="Item Name" required>

    <input type="number" id="quantity" placeholder="Item Quantity" name="quantity" min="1" max="1000" required>
    <input type="number" id="price" placeholder="Asking Price" name="price" min="1" max="1000000" required>

    <button id="start">Create Listing</button>
    </form>
    </div>

    `

    const element2 = document.querySelector('.sidebar');
      element2.innerHTML += `
      <div class="back" onclick="backNui('close')">Back</div>
      `

const quantityForm = document.getElementById('quantityForm');

async function addListing() {
  
  const price = document.getElementById('price').value;
  const quantity = document.getElementById('quantity').value;
  const item = document.getElementById('item').value;

  fetch("https://ds-marketplace/addlisting", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      price, quantity, item
    }),
  });

  fetch("https://ds-marketplace/backnui", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      price,
    }),
  });

}

quantityForm.addEventListener('submit', function(event) {
  event.preventDefault();
  addListing()
});

}

function buyItem2(item, price, quantity, id, citizenid) {

  if (playerMoney > price) {

    fetch("https://ds-marketplace/buyitem", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        item, price, quantity, id, citizenid
      }),
    });

      } else {    

        fetch("https://ds-marketplace/nomoney", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            price,
          }),
        });

        fetch("https://ds-marketplace/backnui", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            businessType: price,
          }),
        });

      }

}

function buyItem(item, price, quantity, label, image, id, citizenid) {

  const element = document.querySelector('.wrapper');
  element.innerHTML = "";
    element.innerHTML += `
      <div class="box2">
      <img class="img2" src= "nui://qb-inventory/html/images/${image}" alt="">

        <div class="pricetag2">$${price}</div>
        <div class="label2">Are You Sure You Want To Purchase: ${label}</div>

        <div class="info">

        <button class="back2" onclick="backNui()">
        <span class="fas fa-arrow-right-to-bracket"></span>
        Back
      </button>

        <button class="buy2" onclick="buyItem2('${item}','${price}','${quantity}','${id}','${citizenid}')">
          <span class="fas fa-cart-shopping"></span>
          Buy
        </button>

        </div>

      </div>
    `
}

window.addEventListener("message", (event) => {
  let eventData = event.data;
  switch (eventData.type) {
    case "show": {
      if (eventData.enable) {

        playerMoney = eventData.playerMoney;
        ownitems = eventData.ownitems;

        if (eventData.nomoney) {

          const element = document.querySelector('.container');
          element.innerHTML += `
          <div class="moneyBox">You Dont Have Enough Money.</div>
          `
          
          $(".moneyBox").fadeIn(100);
      
          setTimeout(function() {

            const elements = document.getElementsByClassName('moneyBox');

            for (let i = 0; i < elements.length; i++) {

              $(elements[i]).fadeOut(200);

            }

        }, 2500);

        } else {

        const element = document.querySelector('.wrapper');
        element.innerHTML = "";
        for (let i = 0; i < eventData.items.length; i++) {
          const data = eventData.items[i];

          element.innerHTML += `
          <div class="box">

          <div class="label">${data.label} (${data.quantity}x)</div>
          <img class="img" src= "nui://qb-inventory/html/images/${data.image}" alt="">
          <div class="pricetag">$${data.price}</div>


          <button class="buy" onclick="buyItem('${data.item}','${data.price}','${data.quantity}','${data.label}','${data.image}','${data.id}','${data.citizenid}')">
                <span class="fas fa-cart-shopping"></span>
                Buy
          </button>

        </div>
          `
        }

        const element2 = document.querySelector('.header-money');
        dollarAmount = playerMoney
        element2.innerHTML = "";
        let formattedAmount = parseFloat(dollarAmount).toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        element2.innerHTML += `
        <div class="money">$ ${formattedAmount} </div>
        `

        const element3 = document.querySelector('.sidebar');
        element3.innerHTML = "";

        element3.innerHTML += `
        <div class="list" onclick="createListing('list')">List Item</div>
        <div class="mylisted" onclick="myListings()">My Listed Items</div>
        <div class="close" onclick="closeNui('close')">Close</div>
        `

        $("body").fadeIn(0);
        $(".full-container").css("filter", "none");
        $(".full-container").fadeOut(0);

        if (eventData.back) {

        $(".full-container").fadeIn(0);

        } else {
        $(".full-container").slideDown(250);
        }
        
        $(".full-container").slideDown(250);
      }
      } else {
        $("body").slideUp(250);
        $(".full-container").slideUp(250);
      } 
    }
  }
});