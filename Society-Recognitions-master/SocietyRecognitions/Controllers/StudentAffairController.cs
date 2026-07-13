using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.InteropServices;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Management;
using System.Web.Services.Description;
using SocietyRecognitions.Models;

namespace SocietyRecognitions.Controllers
{
    public class StudentAffairController : ApiController
    {
        private String constr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SocietySync;Data Source=SAAD\\VE_SERVER";
        private SqlConnection con = null;
        private SqlCommand cmd = null;

        [HttpPost]
        [Route("add_cp")]
        public async Task<IHttpActionResult> add_cp([FromBody] User user)
        {
            // http://192.168.4.135:5000/add_cp
            con = new SqlConnection(constr);
            con.Open();

            String query = $"insert into user1 values ('{user.name}','{user.email}','{user.password}','{user.role}','{user.profilePictureUrl}','{user.designation}')";

            cmd = new SqlCommand(query, con);
            int row_affected = await cmd.ExecuteNonQueryAsync();

            if(row_affected > 0)
            {
                return Ok("Data inserted Successfully"); // status code 200
            }
            else
            {
                return BadRequest("user not accepted"); // status code 400
            }
        }

        // Get the records for student affair in the Review Section
        [HttpGet]
        [Route("Student_affair_req_prev")]
        public async Task<IHttpActionResult> std_affairs_prev()
        {
            // http://192.168.4.135:5000/Student_affair_req_prev
            con = new SqlConnection(constr);
            con.Open();

            List<AffairsHalf> list_half_affairs = new List<AffairsHalf>();

            String query = "select r_id, e_name, e_date from Requisitions where student_affairs_action = ''";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                AffairsHalf af = new AffairsHalf();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                list_half_affairs.Add(af);
            }
            con.Close();

            return Ok(list_half_affairs);
        }

        // After clicking on the event in the Review Section, open a new screen and show the below data 
        // for accepted and rejected
        [HttpGet]
        [Route("Student_affair_req_detail")]
        public async Task<IHttpActionResult> std_affairs_detail(String r_id)
        {
            // http://192.168.4.135:5000/Student_affair_req_full?r_id=3

            con = new SqlConnection(constr);
            con.Open();

            AffairsFull std_req = new AffairsFull();

            String query = "select u_id,r_id, society, e_name, e_venu,e_budget ,e_date, e_time_from, e_time_to, e_type," +
                " staff_req_main,staff_req_other, it_req_main, it_req_other , student_affairs_comments " +
                ", e_description from Requisitions where student_affairs_action = '' and r_id = " + r_id;

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            SqlConnection con2 = new SqlConnection(constr);
            con2.Open();

            while (sdr.Read())
            {

                String id = sdr["u_id"].ToString();

                String u_query = "select name from User1 where id= " + id;

                SqlCommand cmd2 = new SqlCommand(u_query, con2);
                SqlDataReader sdr2 = await cmd2.ExecuteReaderAsync();

                if (sdr2.Read())
                {
                    std_req.username = sdr2["name"].ToString();
                    sdr2.Close();
                }

                std_req.r_id = sdr["r_id"].ToString();
                std_req.society = sdr["society"].ToString();
                std_req.e_name = sdr["e_name"].ToString();
                std_req.e_venu = sdr["e_venu"].ToString();
                std_req.budget = sdr["e_budget"].ToString();
                std_req.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                std_req.e_time_from = DateTime.Parse(sdr["e_time_from"].ToString()).TimeOfDay.ToString();
                std_req.e_time_to = DateTime.Parse(sdr["e_time_to"].ToString()).TimeOfDay.ToString();
                std_req.e_type = sdr["e_type"].ToString();
                std_req.staff_req_main = sdr["staff_req_main"].ToString();
                std_req.staff_req_other = sdr["staff_req_other"].ToString();
                std_req.it_req_main = sdr["it_req_main"].ToString();
                std_req.it_req_other = sdr["it_req_other"].ToString();
                std_req.e_description = sdr["e_description"].ToString();
            }
            con.Close();
            return Ok(std_req);
        }

        [HttpGet]
        [Route("Student_affair_req_full")]
        public async Task<IHttpActionResult> std_affairs_full(String r_id)
        {
            // http://192.168.4.135:5000/Student_affair_req_full?r_id=3

            con = new SqlConnection(constr);
            con.Open();

            AffairsFull std_req = new AffairsFull();

            String query = "select u_id,r_id, society, e_name, e_venu,e_budget ,e_date, e_time_from, e_time_to, e_type," +
                " staff_req_main,staff_req_other, it_req_main, it_req_other , student_affairs_comments " +
                ", e_description from Requisitions where student_affairs_action != '' and r_id = " + r_id;

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            SqlConnection con2 = new SqlConnection(constr);
            con2.Open();

            while (sdr.Read())
            {

                String id = sdr["u_id"].ToString();

                String u_query = "select name from User1 where id= " + id;

                SqlCommand cmd2 = new SqlCommand(u_query, con2);
                SqlDataReader sdr2 = await cmd2.ExecuteReaderAsync();

                if (sdr2.Read())
                {
                    std_req.username = sdr2["name"].ToString();
                    sdr2.Close();
                }

                std_req.r_id = sdr["r_id"].ToString();
                std_req.society = sdr["society"].ToString();
                std_req.e_name = sdr["e_name"].ToString();
                std_req.e_venu = sdr["e_venu"].ToString();
                std_req.budget = sdr["e_budget"].ToString();
                std_req.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                std_req.e_time_from = DateTime.Parse(sdr["e_time_from"].ToString()).TimeOfDay.ToString();
                std_req.e_time_to = DateTime.Parse(sdr["e_time_to"].ToString()).TimeOfDay.ToString();
                std_req.e_type = sdr["e_type"].ToString();
                std_req.staff_req_main = sdr["staff_req_main"].ToString();
                std_req.staff_req_other = sdr["staff_req_other"].ToString();
                std_req.it_req_main = sdr["it_req_main"].ToString();
                std_req.it_req_other = sdr["it_req_other"].ToString();
                std_req.student_affairs_comments = sdr["student_affairs_comments"].ToString();
                std_req.e_description = sdr["e_description"].ToString();
            }
            con.Close();
            return Ok(std_req);
        }

        // accepted or rejected student_affairs_action 
        [HttpPost]
        [Route("sa_mark_status")]
        public async Task<IHttpActionResult> sa_mark_status([FromBody] SAStatusMark sm)
        {
            con = new SqlConnection(constr);
            con.Open();

            String query = $"update Requisitions set student_affairs_action = '{sm.status}' , student_affairs_comments = '{sm.student_affairs_comments}'" +
                $" where r_id = {sm.r_id}";

            cmd = new SqlCommand(query, con);
            int count = await cmd.ExecuteNonQueryAsync();
            con.Close();
            if (count > 0)
            {
                return Ok("Status changed Sucessfully");
            }
            else
            {
                return InternalServerError(new Exception("Failed to update status."));
            }
        }


        // open the Approved section to see all the accepted Events
        [HttpGet]
        [Route("accepted_affair")]
        public async Task<IHttpActionResult> accepted_std_affairs()
        {
            // http://192.168.4.135:5000/accepted_affair
            con = new SqlConnection(constr);
            con.Open();

            List<AffairsHalf> acc_affairs = new List<AffairsHalf>();

            String query = "select r_id, e_name, e_date from Requisitions where student_affairs_action = 'accepted'";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                AffairsHalf af = new AffairsHalf();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                acc_affairs.Add(af);
            }
            con.Close();
            return Ok(acc_affairs);
        }

        // open the Rejected section to see all the rejected Events
        [HttpGet]
        [Route("rejected_affair")]
        public async Task<IHttpActionResult> rejected_std_affairs()
        {
            // http://192.168.4.135:5000/rejected_affair
            con = new SqlConnection(constr);
            con.Open();

            List<AffairsHalf> acc_affairs = new List<AffairsHalf>();

            String query = "select r_id,e_name, e_date from Requisitions where student_affairs_action = 'rejected'";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                AffairsHalf af = new AffairsHalf();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                acc_affairs.Add(af);
            }
            con.Close();
            return Ok(acc_affairs);
        }

        // on the home page, you will see the top 3 names for pending Events
        // also you will see the count of approved, rejected and pending
        [HttpGet]
        [Route("std_summary")]
        public async Task<IHttpActionResult> std_summary()
        {
            // http://192.168.4.135:5000/std_summary
            RequisitionsRecord rr = new RequisitionsRecord();

            con = new SqlConnection(constr);
            con.Open();

            String query = "select top 3 e_name from Requisitions where student_affairs_action = ''";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            if (sdr.Read())
                rr.n1 = sdr["e_name"].ToString();
            if (sdr.Read())
                rr.n2 = sdr["e_name"].ToString();
            if (sdr.Read()) 
                rr.n3 = sdr["e_name"].ToString();

            sdr.Close();

            query = "select student_affairs_action from  Requisitions";
            cmd = new SqlCommand(query, con);
            sdr = await cmd.ExecuteReaderAsync();

            int accepted = 0;
            int rejected = 0;
            int pending = 0;

            while (sdr.Read())
            {
                if (sdr["student_affairs_action"].ToString().Trim() == "accepted")
                {
                    accepted++;
                }
                else if(sdr["student_affairs_action"].ToString().Trim() == "rejected")
                {
                    rejected++;
                }
                else if(sdr["student_affairs_action"].ToString().Trim() == "")
                {
                    pending++;
                }
            }

            rr.rejected = rejected.ToString();
            rr.accepted = accepted.ToString();
            rr.pending = pending.ToString();
            con.Close();
            return Ok(rr);
        }
    }
    public class AffairsFull
    {
        public String r_id { get; set; }
        public String username { get; set; }
        public String society { get; set; }
        public String e_name { get; set; }
        public String e_venu { get; set; }
        public String budget { get; set; }
        public String e_date { get; set; }
        public String e_time_from { get; set; }
        public String e_time_to { get; set; }
        public String e_type { get; set; }
        public String staff_req_main { get; set; }
        public String staff_req_other { get; set; }
        public String it_req_main { get; set; }
        public String it_req_other { get; set; }
        public String student_affairs_comments { get; set; }
        public String e_description { get; set; }
    }

    public class AffairsHalf
    {
        public String r_id { set; get; }
        public String e_name { set; get; }
        public String date { set; get; }
        public float budget { set; get; }
    }

    public class RequisitionsRecord
    {
        public String n1 { get; set; }
        public String n2 { get; set; }
        public String n3 { get; set; }
        public String accepted { get; set; }
        public String rejected { get; set; }
        public String pending { get; set; }
    }

    public class SAStatusMark
    {
        public String r_id { set; get; }
        public String status { set; get; } // status should only be accepted or rejected
        public String student_affairs_comments { set; get; }
    }
}
