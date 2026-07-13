using SocietyRecognitions.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace SocietyRecognitions.Controllers
{
    public class Login
    {
        public String email { get; set; }
        public String password { get; set; }
    }

    public class LoginController : ApiController
    {
        private String constr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SocietySync;Data Source=SAAD\\VE_SERVER";
        private SqlConnection con = null;
        private SqlCommand cmd = null;
        private SqlDataReader sdr = null;

        [HttpPost]
        [Route("login_user")]
        public async Task<IHttpActionResult> login_user([FromBody] Login l)
        {
            //Console.WriteLine(l.email, l.password);

            User u = new User();

            Console.WriteLine("run by PC:1 ");


            con = new SqlConnection(constr);
            con.Open();

            String query = $"SELECT * FROM User1 WHERE email = '{l.email}'  AND password = '{l.password}'";

            cmd = new SqlCommand(query, con);

            SqlDataReader sdr =await cmd.ExecuteReaderAsync();

            if (sdr.Read()) 
            {
                u.id = Convert.ToInt32(sdr["id"]);
                u.name = sdr["name"].ToString();
                u.email = sdr["email"].ToString();
                u.password = sdr["password"].ToString();
                u.role = sdr["role"].ToString();
                u.profilePictureUrl = sdr["profilePictureUrl"].ToString();
                u.designation = sdr["designation"].ToString();
            }

            return Ok(u);

        }

    }
}
