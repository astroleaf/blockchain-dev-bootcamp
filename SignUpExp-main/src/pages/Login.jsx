import { useRef } from "react";
import { useNavigate } from "react-router-dom";
const Login = ()=>{
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
        const res = await fetch("http://localhost:3000/login",{
            method:"POST",
            headers:{
                "Content-Type":"application/json"
            },
            body:JSON.stringify(userInfo)
        })
        const data = await res.json();
        if(data.message==="User Found"){
            alert("Login Successfull")
            navigateTo("/home")
        }else{
            alert("Wrong Credentials")
        }
    }
    const signUp=()=>{
        navigateTo("/signup")
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
            <button type="submit" className="btn btn-primary">Login</button>
            </form>
        </div>
        <div className="position-fixed top-0 end-0 m-3">
            <button type="button" onClick={signUp} className="btn btn-secondary">Sign UP</button>
        </div>
</>
   }
   export default Login;