package com.pubble.conpub.repository;

import com.pubble.conpub.domain.SelectedOption;
import org.springframework.stereotype.Repository;

import javax.persistence.*;

@Repository
public class SelectedOptionRepository {
    @PersistenceContext
    private EntityManager em;

    @PersistenceUnit
    private EntityManagerFactory emf;

    public void save(SelectedOption selectedOption){
        em.persist(selectedOption);
    }

    public void delete(String[] check){

        System.out.println("여기는 SelectedOptionRepository");
        for(String data : check) {

            em.createQuery("delete from SelectedOption s where s.id=: data").setParameter("data",Long.parseLong(data)).executeUpdate();
            System.out.println("삭제 성공!");

        }

    }


}
