import "./Main.css";

function Accounts() {
  return (
    <>
      <form className="label1" id="myForm">
        <label htmlFor="">Select an account</label>
        <select className="innerBox" id="selectNumber">
          <option></option>
        </select>
      </form>
      <span className="conAc">Connected Account: None</span>
      <br></br>
      <span className="acBal">Account Balance:0 ether</span>
      <br></br>
      <span className="provider">Provider : None</span>
    </>
  );
}

export default Accounts;
