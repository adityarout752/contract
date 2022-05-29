//SPDX-License-Identifier:Mit

pragma solidity ^0.8.0;

contract shopping {
    
    struct Product {
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool delivered;

    }

   uint counter =1;
    Product [] public products;
    address payable manager;
    bool destroyed= false;

    modifier isNotDestroyed{ 
        require(!destroyed,"Contract does not exist");
         _;
          }
    event registered(string title,uint productId,address seller);
    event bought(uint productId,address buyer);
     event delivered(uint productId);

     constructor() {
         manager = payable(msg.sender);
     }

    function registerProduct(string memory _title, string memory _desc, uint _price) public  isNotDestroyed {
         require(_price>0 ,"price should be grater than zero");
         Product memory tempProduct;
         tempProduct.title = _title;
         tempProduct.desc =_desc;
         tempProduct.price = _price*10**18;
         tempProduct.seller =payable(msg.sender) ;
         tempProduct.productId = counter;
         products.push(tempProduct);
         counter++;
         
         emit registered(_title,tempProduct.productId, msg.sender);


    }

    function buy(uint _productId) payable public {
        require(products[_productId-1].price == msg.value ,"please pay the exact price");
         require(products[_productId-1].seller != msg.sender ,"seller  cannot buy the product");
         products[_productId-1].buyer = msg.sender;

     emit bought(_productId, msg.sender);
    }

    function delivery(uint _productId) public payable {
           require(products[_productId-1].buyer == msg.sender ,"only buyer  confirm buy ");
                 products[_productId-1].delivered = true;
                 products[_productId-1].seller.transfer(products[_productId-1].price);
                 emit delivered(_productId);

    }

    function destroy() public {
     require(manager == msg.sender ,"only manager is allowed to destruct");
     selfdestruct(manager);

    }
}