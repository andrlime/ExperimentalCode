import axios from "axios";

axios.get("https://frsmwsyapc.us-east-2.awsapprunner.com/test").then((rs) => {
	console.log(rs);
});
