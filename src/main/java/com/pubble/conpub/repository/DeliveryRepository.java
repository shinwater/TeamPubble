package com.pubble.conpub.repository;

import com.pubble.conpub.domain.Delivery;
import org.springframework.stereotype.Repository;

import javax.persistence.*;
import java.util.List;

@Repository
public class DeliveryRepository {

    @PersistenceContext
    private EntityManager em;

    @PersistenceUnit
    private EntityManagerFactory emf;

    public void save(Delivery delivery){
        em.persist(delivery);
    }

    public List<Delivery> find(Long no){
        return em.createQuery("select d from Delivery d where d.deliveryMember.id=:member_no",Delivery.class).setParameter("member_no",no).getResultList();
    }
}
