//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Library {
    event AddBook(address recepient, uint bookId);
     event SetFinished(uint bookId, bool finished);

    struct Book {
        uint id;
        string name;
        uint year;
        string author;
        bool finished;
    }

    Book[] private bookList;

    mapping(uint => address) bookToOwner;

    function addBook(string memory name, uint year, string memory author, bool finished) external {
        uint bookId = bookList.length;
        bookList.push(Book(bookId, name, year, author, finished));
        bookToOwner[bookId] = msg.sender;
        emit AddBook(msg.sender, bookId);
    }

    function _getBookList(bool _finished) private view returns(Book[] memory){
        uint counter = 0;
        Book[] memory temporary = new Book[](bookList.length);
        for(uint i=0; i< bookList.length; i++){
            if(bookToOwner[i] == msg.sender && bookList[i].finished == _finished){
                temporary[counter] = bookList[i];
                counter++;
            }
        }

        Book[] memory result = new Book[](counter);
        for(uint i=0;i<counter;i++){
            result[i] = temporary[i];
        }
        
        return result;
    }



    function getFinishedBooks() external view returns (Book[] memory) {
    return _getBookList(true);
    }

    function getUnfinishedBooks() external view returns (Book[] memory) {
     return _getBookList(false);
  }

   function setFinished(uint bookId, bool finished) external {
    if (bookToOwner[bookId] == msg.sender) {
      bookList[bookId].finished = finished;
      emit SetFinished(bookId, finished);
    }
  }
}