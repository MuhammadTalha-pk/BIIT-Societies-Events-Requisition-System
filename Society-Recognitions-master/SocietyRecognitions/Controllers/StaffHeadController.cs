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
    public class StaffHeadController : ApiController
    {
        private String constr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SocietySync;Data Source=SAAD\\VE_SERVER";
        private SqlConnection con = null;
        private SqlCommand cmd = null;

        [HttpGet]
        [Route("staff_summary")]
        public async Task<IHttpActionResult> staff_summary()
        {
            // http://192.168.4.135:5000/staff_summary
            Summary_Card it_summary = new Summary_Card();

            con = new SqlConnection(constr);
            con.Open();

            String query = "SELECT top 3 e_name FROM Requisitions WHERE student_affairs_action = 'accepted' and account_office_action = 'accepted' and CONVERT(DATE, e_date) = CONVERT(DATE, GETDATE());";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            if (sdr.Read()) 
                it_summary.n1 = sdr["e_name"].ToString();
            if (sdr.Read()) 
                it_summary.n2 = sdr["e_name"].ToString();
            if (sdr.Read()) 
                it_summary.n3 = sdr["e_name"].ToString();

            sdr.Close();

            query = "select e_name , e_date from  Requisitions where student_affairs_action = 'accepted' and account_office_action = 'accepted'";
            cmd = new SqlCommand(query, con);
            sdr = await cmd.ExecuteReaderAsync();

            int total = 0;
            int today = 0;
            int tomorrow = 0;

            DateTime today_date = DateTime.Now.Date;
            DateTime tomorrow_date = today_date.Date.AddDays(1);

            while (sdr.Read())
            {
                total++;

                if (DateTime.Parse(sdr["e_date"].ToString().Trim()) == today_date)
                {
                    today++;
                }
                else if (DateTime.Parse(sdr["e_date"].ToString().Trim()) == tomorrow_date)
                {
                    tomorrow++;
                }
            }

            it_summary.total = total.ToString();
            it_summary.today = today.ToString();
            it_summary.tomorrow = tomorrow.ToString();
            con.Close();
            return Ok(it_summary);
        }

        [HttpGet]
        [Route("Staff_detail")]
        public async Task<IHttpActionResult> staff_full(String r_id)
        {
            // http://192.168.4.135:5000/Staff_detail?r_id=3

            con = new SqlConnection(constr);
            con.Open();

            StaffDetails staff_detail = new StaffDetails();

            String query = "select society, e_name, e_venu,e_date, e_time_from, e_time_to, e_type," +
                " staff_req_main, staff_req_other from Requisitions where r_id = " + r_id;

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                staff_detail.society = sdr["society"].ToString();
                staff_detail.e_name = sdr["e_name"].ToString();
                staff_detail.e_venu = sdr["e_venu"].ToString();
                staff_detail.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                staff_detail.e_time_from = DateTime.Parse(sdr["e_time_from"].ToString()).TimeOfDay.ToString();
                staff_detail.e_time_to = DateTime.Parse(sdr["e_time_to"].ToString()).TimeOfDay.ToString();
                staff_detail.e_type = sdr["e_type"].ToString();
                staff_detail.staff_requirments_main = sdr["staff_req_main"].ToString();
                staff_detail.staff_requirments_other = sdr["staff_req_other"].ToString();
            }
            con.Close();
            return Ok(staff_detail);
        }

        [HttpGet]
        [Route("Staff_req_pending")]
        public async Task<IHttpActionResult> staff_pending()
        {
            // http://192.168.4.135:5000/Staff_req_pending
            con = new SqlConnection(constr);
            con.Open();

            List<StaffView> list_staffPending = new List<StaffView>();

            String query = "SELECT r_id, e_name , e_date FROM Requisitions WHERE " +
                "student_affairs_action = 'accepted' and account_office_action = 'accepted' " +
                "and CONVERT(DATE, e_date) >= CONVERT(DATE, GETDATE());";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                StaffView af = new StaffView();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                list_staffPending.Add(af);
            }
            con.Close();
            return Ok(list_staffPending);
        }

        [HttpGet]
        [Route("Staff_req_completed")]
        public async Task<IHttpActionResult> staff_completed()
        {
            // http://192.168.4.135:5000/Staff_req_completed
            con = new SqlConnection(constr);
            con.Open();

            List<StaffView> list_staffCompleted = new List<StaffView>();

            String query = "SELECT r_id, e_name , e_date FROM Requisitions WHERE " +
                "student_affairs_action = 'accepted' and account_office_action = 'accepted' " +
                "and CONVERT(DATE, e_date) < CONVERT(DATE, GETDATE());";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                StaffView sp = new StaffView();
                sp.r_id = sdr["r_id"].ToString();
                sp.e_name = sdr["e_name"].ToString();
                sp.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                list_staffCompleted.Add(sp);
            }
            con.Close();
            return Ok(list_staffCompleted);
        }

    }

    public class StaffView
    {
        public String r_id { set; get; }
        public String e_name { set; get; }
        public String date { set; get; }
    }

    public class StaffDetails
    {
        public String society { get; set; }
        public String e_name { get; set; }
        public String e_venu { get; set; }
        public String e_date { get; set; }
        public String e_time_from { get; set; }
        public String e_time_to { get; set; }
        public String e_type { get; set; }
        public String staff_requirments_main { get; set; }
        public String staff_requirments_other { get; set; }
    }

    public class Summary_Card
    {
        public String n1 { get; set; }
        public String n2 { get; set; }
        public String n3 { get; set; }
        public String total { get; set; }
        public String today { get; set; }
        public String tomorrow { get; set; }
    }
}
