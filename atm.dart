import 'dart:io';
import 'account.dart';

class Atm {
  var listAccount = new List.empty();
  Account? account1, account2;
  void run() {
    account1 = Account(
        accountNumber: '1234',
        pin: '109809',
        accountName: 'irgi',
        balance: 1000000);

    account2 = Account(
        accountNumber: '5678',
        pin: '098712',
        accountName: 'ahmad',
        balance: 500000);

    listAccount = [account1, account2];
    _inputPin();
  }

  _inputPin() {
    stdout.write("Input pin number:");
    var pin = stdin.readLineSync();
    if (_isAccountExist(pin, 'pin')) {
      _menu(pin);
    } else {
      stdout.writeln("No such account.");
      _inputPin();
    }
  }

  _menu(var pin) {
    stdout.writeln("Choose menu");
    stdout.writeln("===========");
    stdout.writeln("1.Transfer");
    stdout.writeln("2.Tarik Tunai");
    stdout.writeln("3.Setor Tunai");
    stdout.writeln("4.Check balance");
    stdout.writeln("5.End Session");
    stdout.writeln("6.Exit");
    stdout.write("Choice: ");
    var input = stdin.readLineSync();
    _action(pin, input);
  }

  _action(var pin, var input) {
    switch (input) {
      case '1':
        //Transfer
        {
          stdout.write("Input account number: ");
          var accountNumber = stdin.readLineSync();
          if (_isAccountExist(accountNumber, 'accountNumber')) {
            stdout.write("Nominal: ");
            var inputNominal = stdin.readLineSync();
            if (_isBalanceValid(inputNominal, pin)) {
              _balanceAction(
                  int.parse(inputNominal!),
                  accountNumber,
                  //add balance to targeted account number
                  'accountNumber',
                  'add',
                  pin);
              //min balance to user that transfer they balance
              stdout.writeln(pin);
              _balanceAction(
                  int.parse(inputNominal),
                  pin,
                  //add balance to targeted account number
                  'pin',
                  'min',
                  pin);
              _continueTransition(pin);
            } else {
              stdout.writeln('Balance is not enough.');
              _continueTransition(pin);
            }
          } else {
            stdout.writeln("No such account.");
          }
        }
        break;
      case '2':
        //Tarik tunai
        {
          stdout.write("Nominal: ");
          var inputNominal = stdin.readLineSync();
          if (_isBalanceValid(inputNominal, pin)) {
            _balanceAction(int.parse(inputNominal!), pin, 'pin', 'min', pin);
            _continueTransition(pin);
          } else {
            stdout.writeln('Balance is not enough.');
            _continueTransition(pin);
          }
        }
        break;
      case '3':
        //Setor tunai
        {
          stdout.write("Nominal: ");
          var inputNominal = stdin.readLineSync();
          if (_isBalanceValid(inputNominal, pin)) {
            _balanceAction(int.parse(inputNominal!), pin, 'pin', 'add', pin);
            _continueTransition(pin);
          } else {
            stdout.writeln('Balance is not enough.');
            _continueTransition(pin);
          }
        }
        break;
      case '4':
        //check balance
        {
          _balanceAction(0, pin, 'pin', 'check', pin);
          _continueTransition(pin);
        }
        break;
      case '5':
        {
          stdout.writeln("Last session is ended.");
          _inputPin();
        }
        break;
      case '6':
        {
          exit(0);
        }
    }
  }

  bool _isAccountExist(var pinOrNumber, String property) {
    var isExist = false;
    listAccount.forEach((element) {
      if (pinOrNumber == element[property]) {
        isExist = true;
      }
    });
    return isExist;
  }

  bool _isBalanceValid(var inputedNominal, var pin) {
    var isValid = false;
    listAccount.forEach((element) {
      if (pin == element['pin']) {
        if (int.parse(inputedNominal) < element['balance']) {
          isValid = true;
        }
      }
    });
    return isValid;
  }

  _continueTransition(var pin) {
    if (_isContinued()) {
      _menu(pin);
    }
  }

  _balanceAction(
      var newBalance, var pinOrNumber, var property, var operation, var pin) {
    listAccount.forEach((element) {
      if (pinOrNumber == element[property]) {
        if (operation == 'add') {
          element['balance'] += newBalance;
          stdout.writeln('Balance is added.');
        }
        if (operation == 'min') {
          element['balance'] -= newBalance;
          stdout.writeln('your balance is reduced');
        }
        if (operation == 'check') {
          stdout.writeln('      Your Balance      ');
          stdout.writeln('=========================');
          stdout.writeln(element['balance']);
        }
      }
    });
  }

  bool _isContinued() {
    stdout.write('Continue transaction(y/n)?');
    var answer = stdin.readLineSync();
    if (answer?.toLowerCase() == 'y') {
      return true;
    } else {
      exit(0);
    }
  }
}
