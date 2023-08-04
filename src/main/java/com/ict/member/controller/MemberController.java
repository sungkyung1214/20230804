package com.ict.member.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ict.member.model.service.MemberService;
import com.ict.member.model.vo.MemberVO;

@Controller
public class MemberController {

	//DB가기 위해서 하는 서비스~
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@GetMapping("/member_reg.do")
	public ModelAndView getMemberRegForm() {
		return new ModelAndView("members/addForm");
	}
	
	@PostMapping("/member_add.do")
	public ModelAndView getMemberAdd(MemberVO m2vo) {
		ModelAndView mv= new ModelAndView("redirect:/");
										//"/"= root, 루트는 컨트롤러 
		
		// 패스워드 암호화 하자 >>>DB에서 char60 으로 정해져있음
		String pwd = m2vo.getM_pw();
		m2vo.setM_pw(passwordEncoder.encode(pwd));
		// 윗줄을 한줄로 만들면 아래처럼!!
		//m2vo.setM_pw(passwordEncoder.encode(m2vo.getM_pw()));
		
		int result = memberService.getMemberAdd(m2vo);
		return mv;
	}
	
	@PostMapping("/member_login.do")
	public ModelAndView getMemberLogIn(MemberVO m2vo, HttpSession session) {
		ModelAndView mv = new ModelAndView("redirect:/");
		// 입력한 id의 패스워드를 DB에 가져와서 입력한 pwd와 비교해서 맞으면 성공 틀리면 실패
		// id로 DB에 저장된 pwd 가져오기
		
		MemberVO pwd = memberService.getMemberPwd(m2vo.getM_id());
		if(! passwordEncoder.matches(m2vo.getM_pw(),pwd.getM_pw())) {
			session.setAttribute("loginChk", "fail");
			return mv;
		}else {
			session.setAttribute("loginChk", "ok");
			session.setAttribute("m2vo", pwd);
			return mv;
		}
	}		
}
