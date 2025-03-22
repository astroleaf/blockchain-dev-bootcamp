import { useRef } from "react";
import { useNavigate } from "react-router-dom";
const SignUp = ()=>{
    const emailRef = useRef();
    const passwordRef = useRef();
    const navigateTo =useNavigate();
    const handleSubmit=async(event)=>{
        event.preventDefault();
        const email=emailRef.current.value;
        const password = passwordRef.current.value;

        const userInfo={
            email:email,
            password:password
        }
        console.log(userInfo)
        const res = await fetch("http://localhost:3000/signup",{
            method:"POST",
            headers:{
                "Content-Type":"application/json"
            },
            body:JSON.stringify(userInfo)
        })
        const data = await res.json();
        if(data.message==="Registration Successful"){
            alert("Registration Successful")
            navigateTo("/home")
        }else{
            alert("User Already Exist")
        }
    }
    return <>
    <div className="border p-4">
        <form onSubmit={handleSubmit}>
        <div className="mb-3">
            <label htmlFor="exampleInputEmail1" className="form-label">Email address</label>
            <input type="email" className="form-control" id="email"  ref={emailRef} aria-describedby="emailHelp"/>
            <div id="emailHelp" className="form-text">.</div>
        </div>
        <div className="mb-3">
            <label htmlFor="exampleInputPassword1" className="form-label">Password</label>
            <input type="password" className="form-control" id="password" ref={passwordRef}/>
        </div>
        <button type="submit" className="btn btn-primary">Sign Up</button>
        </form>
    </div>
    </>
   }
   export default SignUp;
//meet you at 8:20 complete the signup page