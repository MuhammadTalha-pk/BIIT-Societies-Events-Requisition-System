using Society_Requisitions.Models;
using SocietyRecognitions.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Services.Description;

namespace SocietyRecognitions.Controllers
{
    public class ChairPersonController : ApiController
    {
        private String constr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SocietySync;Data Source=SAAD\\VE_SERVER";
        private SqlConnection con = null;
        private SqlCommand cmd = null;

        [HttpGet]
        [Route("check_origin")]
        public IHttpActionResult CheckOrigin()
        {
            var serverName = Environment.MachineName;
            return Ok("Handled by: " + serverName);
        }


        [HttpPost]
        [Route("add_requisition")]
        public async Task<IHttpActionResult> Add_requisition([FromBody] Requisition r)
        {
            if (r == null)
            {
                return BadRequest("Requisition data is null.");
            }

            con = new SqlConnection(constr);
            con.Open();


            String query = $"INSERT INTO Requisitions VALUES ({r.u_id}, '{r.e_name}', '{r.e_venu}', {r.e_budget}, '{r.e_date}', '{r.e_time_from}'," +
                $"'{r.e_time_to}', '{r.e_type}', '{r.staff_req_main}', '{r.staff_req_other}', '{r.it_req_main}','{r.it_req_other}'," +
                $"'{r.e_description}','{r.student_affairs_action}','{r.student_affairs_comments}','{r.account_office_action}','{r.account_office_comments}','{r.society}')";
            
            cmd = new SqlCommand(query, con);
            
            int rowsAffected = await cmd.ExecuteNonQueryAsync();
            
            con.Close();
            if (rowsAffected > 0)
            {
                return Content(HttpStatusCode.Created, "Requisition added successfully by PC 1.");
            }
            else
            {
                return InternalServerError(new Exception("Failed to add requisition."));
            }

        }

        [HttpGet]
        [Route("cp_summary")]
        public async Task<IHttpActionResult> cp_summary(int u_id)
        {
            // http://192.168.4.135:5000/cp_summary/?u_id=3
            CPSummary cp_s = new CPSummary();

            con = new SqlConnection(constr);
            con.Open();

            String query = "SELECT TOP 3 e_name, student_affairs_action, account_office_action FROM Requisitions where u_id = "+u_id+" ORDER BY r_id DESC;";
            cmd = new SqlCommand(query, con);

            var sdr = await cmd.ExecuteReaderAsync();

            if (sdr.Read())
            {
                cp_s.n1 = sdr["e_name"].ToString();
                if (sdr["student_affairs_action"].ToString() == "accepted" && sdr["account_office_action"].ToString() == "accepted")
                {
                    cp_s.s1 = "accepted";
                }
                else if ((sdr["student_affairs_action"].ToString() == "accepted" || sdr["student_affairs_action"].ToString().Trim() == "") 
                    && sdr["account_office_action"].ToString().Trim() == "") // "" means pending status
                {
                    cp_s.s1 = "pending";
                }
                else if (sdr["student_affairs_action"].ToString() == "rejected" || sdr["account_office_action"].ToString() == "rejected")
                {
                    cp_s.s1 = "rejected";
                }
            }

            if (sdr.Read())
            {
                cp_s.n2 = sdr["e_name"].ToString();
                if (sdr["student_affairs_action"].ToString() == "accepted" && sdr["account_office_action"].ToString() == "accepted")
                {
                    cp_s.s2 = "accepted";
                }
                else if ((sdr["student_affairs_action"].ToString() == "accepted" || sdr["student_affairs_action"].ToString().Trim() == "")
                    && sdr["account_office_action"].ToString().Trim() == "") // "" means pending status
                {
                    cp_s.s2 = "pending";
                }
                else if (sdr["student_affairs_action"].ToString() == "rejected" || sdr["account_office_action"].ToString() == "rejected")
                {
                    cp_s.s2 = "rejected";
                }
            }

            if (sdr.Read())
            {
                cp_s.n3 = sdr["e_name"].ToString();
                if (sdr["student_affairs_action"].ToString() == "accepted" && sdr["account_office_action"].ToString() == "accepted")
                {
                    cp_s.s3 = "accepted";
                }
                else if ((sdr["student_affairs_action"].ToString() == "accepted" || sdr["student_affairs_action"].ToString().Trim() == "")
                    && sdr["account_office_action"].ToString().Trim() == "") // "" means pending status
                {
                    cp_s.s3 = "pending";
                }
                else if (sdr["student_affairs_action"].ToString() == "rejected" || sdr["account_office_action"].ToString() == "rejected")
                {
                    cp_s.s3 = "rejected";
                }
            }

            sdr.Close();

            int accepted = 0;
            int rejected = 0;
            int pending = 0;
            query = "select e_name, student_affairs_action, account_office_action FROM Requisitions where u_id = "+u_id;
            cmd = new SqlCommand(query, con);
            sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                if (sdr["student_affairs_action"].ToString() == "accepted" && sdr["account_office_action"].ToString() == "accepted")
                {
                    accepted++;
                }
                else if ((sdr["student_affairs_action"].ToString() == "accepted" || sdr["student_affairs_action"].ToString().Trim() == "")
                    && sdr["account_office_action"].ToString().Trim() == "") // "" means pending status
                {
                    pending++;
                }
                else if (sdr["student_affairs_action"].ToString() == "rejected" || sdr["account_office_action"].ToString() == "rejected")
                {
                    rejected++;
                }
            }

            cp_s.approved = accepted.ToString();
            cp_s.pending = pending.ToString();
            cp_s.rejected = rejected.ToString();

            con.Close();

            return Ok(cp_s);
        }

        public bool IsDateTodayOrLast7Days(DateTime dateToCheck)
        {
            DateTime today = DateTime.Today;
            DateTime sevenDaysAgo = today.AddDays(-7);

            if (dateToCheck.Date == today ||
                (dateToCheck.Date >= sevenDaysAgo && dateToCheck.Date < today))
            {
                return true;
            }
            return false;
        }

        [HttpGet]
        [Route("status_tracker")]
        public async Task<IHttpActionResult> cp_status(int u_id)
        {
            // http://192.168.4.135:5000/status_tracker/?u_id=3

            List<StatusTracker> cp_st = new List<StatusTracker>();
            List<StatusTracker> all_status = new List<StatusTracker>();

            con = new SqlConnection(constr);
            con.Open();

            String query = " SELECT e_name, student_affairs_action, account_office_action, e_date FROM Requisitions WHERE u_id = "+u_id;
            cmd = new SqlCommand(query, con);

            var sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                StatusTracker st = new StatusTracker();
                st.e_name = sdr["e_name"].ToString();
                st.e_date = DateTime.Parse(sdr["e_date"].ToString());

                if (sdr["student_affairs_action"].ToString() == "accepted" && sdr["account_office_action"].ToString().Trim() == "")
                {
                    st.e_status = "In-Process";
                }
                else if (sdr["student_affairs_action"].ToString().Trim() == "" && sdr["account_office_action"].ToString().Trim() == "") // "" means pending status
                {
                    st.e_status = "Pending";
                }
                else if (sdr["student_affairs_action"].ToString() == "rejected" || 
                    sdr["account_office_action"].ToString() == "rejected" || 
                    sdr["account_office_action"].ToString() == "accepted")
                {
                    st.e_status = "Completed";
                }
                all_status.Add(st);
            }

            foreach(var i in all_status)
            {
                if (i.e_status == "Pending" || i.e_status == "In-Process")
                {
                    cp_st.Add(i);
                }
                else if(i.e_status == "Completed" && IsDateTodayOrLast7Days(i.e_date))
                {
                    cp_st.Add(i);
                }
            }

            con.Close();
            return Ok(cp_st);
        }

        [HttpGet]
        [Route("all_task")]
        public async Task<IHttpActionResult> all_task(int u_id)
        {
            // http://192.168.4.135:5000/all_task/?u_id=3

            List<AllTask> cp_tasks = new List<AllTask>();

            con = new SqlConnection(constr);
            con.Open();

            String query = "select r_id, e_name , e_date , student_affairs_action, account_office_action FROM Requisitions WHERE u_id = "+u_id;
            cmd = new SqlCommand(query, con);

            var sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                AllTask task = new AllTask();
                task.r_id = sdr["r_id"].ToString();
                task.e_name = sdr["e_name"].ToString();
                task.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                if (sdr["student_affairs_action"].ToString() == "accepted" && sdr["account_office_action"].ToString() == "accepted")
                {
                    task.e_status = "Accepted";
                }
                else if ((sdr["student_affairs_action"].ToString() == "accepted" || sdr["student_affairs_action"].ToString().Trim() == "")
                    && sdr["account_office_action"].ToString().Trim() == "") // "" means pending status
                {
                    task.e_status = "Pending";
                }
                else if (sdr["student_affairs_action"].ToString() == "rejected" || sdr["account_office_action"].ToString() == "rejected")
                {
                    task.e_status = "Rejected";
                }
                cp_tasks.Add(task);
            }
            con.Close();
            return Ok(cp_tasks);
        }

        [HttpGet]
        [Route("event_detail")]
        public async Task<IHttpActionResult> event_details(int r_id)
        {
            //http://192.168.4.135:5000/event_detail?r_id=3

            con = new SqlConnection(constr);
            con.Open();

            String query = "select * FROM Requisitions WHERE r_id = "+r_id;
            cmd = new SqlCommand(query, con);

            var sdr = await cmd.ExecuteReaderAsync();

            Requisition r = new Requisition();
            if (sdr.Read())
            {
                r.society = sdr["society"].ToString();
                r.e_name = sdr["e_name"].ToString();
                r.e_venu = sdr["e_venu"].ToString();
                r.e_budget = sdr["e_budget"].ToString();
                r.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                r.e_time_from = DateTime.Parse(sdr["e_time_from"].ToString()).TimeOfDay.ToString();
                r.e_time_to = DateTime.Parse(sdr["e_time_to"].ToString()).TimeOfDay.ToString();
                r.e_type = sdr["e_type"].ToString();
                r.staff_req_main = sdr["staff_req_main"].ToString();
                r.staff_req_other = sdr["staff_req_other"].ToString();
                r.it_req_main = sdr["it_req_main"].ToString();
                r.it_req_other = sdr["it_req_other"].ToString();
                r.e_description = sdr["e_description"].ToString();
                r.student_affairs_action = sdr["student_affairs_action"].ToString();
                r.student_affairs_comments = sdr["student_affairs_comments"].ToString();
                r.account_office_action = sdr["account_office_action"].ToString();
                r.account_office_comments = sdr["account_office_comments"].ToString();
            }

            return Ok(r);

        }
    }

    public class AllTask
    {
        public String r_id { get; set; }
        public String e_name { set; get; }
        public String e_status { get; set; }
        public String e_date { get; set; }
    }

    public class StatusTracker
    {
        public String e_name { set; get; }
        public String e_status { get; set; }
        public DateTime e_date { get; set; }
    }

    public class CPSummary
    {
        public String n1 { get; set; }
        public String n2 { get; set; }
        public String n3 { get; set; }
        public String s1 { get; set; }
        public String s2 { get; set; }
        public String s3 { get; set; }
        public String approved { get; set; } // count of approved requests
        public String pending { get; set; } // count of pending requests
        public String rejected { get; set; } // count of rejected requests
    }
}
